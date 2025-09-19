import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:gocheck/models/user.dart';
import 'package:gocheck/models/scooter.dart';
import 'package:gocheck/models/booking.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.id).set(user.toJson());
  }

  Future<User?> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  // Scooters
  Future<List<Scooter>> getScootersByLocation(String location) async {
    QuerySnapshot query = await _db.collection('scooters').where('location', isEqualTo: location).get();
    return query.docs.map((doc) => Scooter.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<Scooter?> getScooterByPlate(String plate) async {
    QuerySnapshot query = await _db.collection('scooters').where('plate', isEqualTo: plate).get();
    if (query.docs.isNotEmpty) {
      return Scooter.fromJson(query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
    }
    return null;
  }

  Future<void> updateScooterStatus(String scooterId, String status) async {
    await _db.collection('scooters').doc(scooterId).update({'status': status});
  }

  // Bookings
  Future<void> createBooking(Booking booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toJson());
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    QuerySnapshot query = await _db.collection('bookings').where('userId', isEqualTo: userId).get();
    return query.docs.map((doc) => Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<Booking?> getActiveBookingForScooter(String scooterId) async {
    QuerySnapshot query = await _db.collection('bookings').where('scooterId', isEqualTo: scooterId).where('status', isEqualTo: 'Active').get();
    if (query.docs.isNotEmpty) {
      return Booking.fromJson(query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
    }
    return null;
  }

  Future<void> updateBooking(String bookingId, Map<String, dynamic> data) async {
    await _db.collection('bookings').doc(bookingId).update(data);
  }

  // Populate sample data
  Future<void> populateSampleData() async {
    // Sample scooters data
    List<Map<String, dynamic>> scooters = [
      {
        'plate': 'B3337PJV',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'MUHAMMAD LUKMAN ARDIANSYAH',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3434PJV',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'CHORIQ RACHMAN',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3011PLJ',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'YADID TAQWA MIFTAQUL HUDA',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3017PLK',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'M ERWIN KURNIAWAN',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3087PLK',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'AGUNG DWI SETYAWAN',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3148PLL',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'RADITYA INDRAKA H',
        'location': 'Malang',
        'status': 'Available',
      },
      {
        'plate': 'B3156PLK',
        'model': 'HONDA BEAT SPORTY CBS ISS 2021',
        'owner': 'NANANG PURWANTO',
        'location': 'Malang',
        'status': 'Available',
      },
      // Add more for Batu and Jember if needed
    ];

    for (var scooter in scooters) {
      await _db.collection('scooters').doc(scooter['plate']).set(scooter);
    }
  }
}
