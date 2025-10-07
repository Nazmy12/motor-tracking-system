import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:gocheck/models/user.dart';
import 'package:gocheck/models/motorcycle.dart';
import 'package:gocheck/models/borrow_request.dart';
import 'package:gocheck/models/return.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.id).set(user.toJson());
  }
  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        // Print document data to verify it's being fetched
        print("User document data: ${doc.data()}");
        return User.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('Document with userId: $userId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      QuerySnapshot query = await _db.collection('users').where('email', isEqualTo: email).get();
      if (query.docs.isNotEmpty) {
        return User.fromJson(query.docs.first.data() as Map<String, dynamic>);
      } else {
        print('No user found with email: $email');
        return null;
      }
    } catch (e) {
      print('Error fetching user by email: $e');
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    data.removeWhere((key, value) => value == null);
    await _db.collection('users').doc(userId).update(data);
  }

  // Motorcycles
  Future<List<Motorcycle>> getMotorcyclesByLocation(String location) async {
    QuerySnapshot query = await _db.collection('motorcycles').where('location', isEqualTo: location).get();
    return query.docs.map((doc) => Motorcycle.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<List<Motorcycle>> getMotorcyclesByOwner(String ownerID) async {
    QuerySnapshot query = await _db.collection('motorcycles').where('ownerID', isEqualTo: ownerID).get();
    return query.docs.map((doc) => Motorcycle.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<Motorcycle?> getMotorcycleBySerial(String serialNumber) async {
    DocumentSnapshot doc = await _db.collection('motorcycles').doc(serialNumber).get();
    if (doc.exists) {
      return Motorcycle.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<void> updateMotorcycleStatus(String serialNumber, String borrowStatus, String returnStatus) async {
    await _db.collection('motorcycles').doc(serialNumber).update({
      'borrowStatus': borrowStatus,
      'returnStatus': returnStatus,
    });
  }

  // Borrow Requests
  Future<void> createBorrowRequest(BorrowRequest request) async {
    await _db.collection('borrow_requests').doc(request.borrowRequestID).set(request.toJson());
  }

  Future<List<BorrowRequest>> getBorrowRequestsByUser(String userID) async {
    QuerySnapshot query = await _db.collection('borrow_requests').where('userID', isEqualTo: userID).get();
    return query.docs.map((doc) => BorrowRequest.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<BorrowRequest?> getActiveBorrowRequestForMotorcycle(String serialNumber) async {
    QuerySnapshot query = await _db.collection('borrow_requests')
        .where('motorcycleID', isEqualTo: serialNumber)
        .where('status', isEqualTo: 'active')
        .get();
    if (query.docs.isNotEmpty) {
      return BorrowRequest.fromJson(query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
    }
    return null;
  }

  Future<void> updateBorrowRequest(String requestID, Map<String, dynamic> data) async {
    data.removeWhere((key, value) => value == null);
    await _db.collection('borrow_requests').doc(requestID).update(data);
  }

  // Returns
  Future<void> createReturn(Return returnRecord) async {
    await _db.collection('returns').doc(returnRecord.returnID).set(returnRecord.toJson());
  }

  Future<List<Return>> getReturnsByUser(String userID) async {
    QuerySnapshot query = await _db.collection('returns').where('userID', isEqualTo: userID).get();
    return query.docs.map((doc) => Return.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // Populate new collections from CSV
  Future<void> populateFromCSV() async {
    try {
      print('Starting CSV population...');
      String csvData = await rootBundle.loadString('assets/sample_data/Pengguna KBM agustus 2025.csv');
      print('CSV data loaded, length: ${csvData.length}');
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData, eol: '\n');
      print('CSV parsed, rows: ${csvTable.length}');
      print('First few rows: ${csvTable.take(3)}');

      // Skip header
      csvTable = csvTable.sublist(1);

      // Filter out unwanted productSeries
      Set<String> excludedSeries = {
        'SK-SKYW-TOYOTA-HILUX',
        'SK-PICK-DHATSU-GMAX',
        'SK-STTN-TOYOTA-AVZA',
      };

      Map<String, User> users = {};
      Map<String, Motorcycle> motorcycles = {};

      for (var row in csvTable) {
        if (row.length < 6) continue; // Skip invalid rows
        String nik = row[0].toString().trim();
        String pemakai = row[1].toString().trim();
        String position = row[2].toString().trim();
        String productSeries = row[3].toString().trim();
        String namaProduct = row[4].toString().trim();
        String serialNumber = row[5].toString().trim();

        // Skip if productSeries is in excluded list
        if (excludedSeries.contains(productSeries)) continue;

        // Skip if any required field is empty
        if (nik.isEmpty || pemakai.isEmpty || serialNumber.isEmpty) continue;

        // Create or update user
        if (!users.containsKey(nik)) {
          users[nik] = User(
            id: nik,
            name: pemakai,
            position: position,
          );
        }

        // Create motorcycle
        Motorcycle motorcycle = Motorcycle(
          serialNumber: serialNumber,
          model: namaProduct,
          productSeries: productSeries,
          ownerID: nik,
          borrowStatus: 'available',
          returnStatus: 'not returned',
          location: 'Malang', // Default location
        );
        motorcycles[serialNumber] = motorcycle;
      }

      print('Users to save: ${users.length}');
      print('Motorcycles to save: ${motorcycles.length}');

      // Save users
      for (var user in users.values) {
        await createUser(user);
        print('Saved user: ${user.id}');
      }

      // Save motorcycles
      for (var motorcycle in motorcycles.values) {
        await _db.collection('motorcycles').doc(motorcycle.serialNumber).set(motorcycle.toJson());
        print('Saved motorcycle: ${motorcycle.serialNumber}');
      }

      print('CSV population completed successfully');
    } catch (e) {
      print('Error in populateFromCSV: $e');
      rethrow;
    }
  }
}
