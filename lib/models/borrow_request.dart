import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowRequest {
  final String borrowRequestID;
  final String userID;
  final String motorcycleID;
  final DateTime borrowTimestamp;
  final String nic;
  final String name;
  final String status;
  final DateTime? returnDate;
  final String notes;

  BorrowRequest({
    required this.borrowRequestID,
    required this.userID,
    required this.motorcycleID,
    required this.borrowTimestamp,
    required this.nic,
    required this.name,
    required this.status,
    this.returnDate,
    required this.notes,
  });

  factory BorrowRequest.fromJson(Map<String, dynamic> json, String id) {
    return BorrowRequest(
      borrowRequestID: id,
      userID: json['userID'] ?? '',
      motorcycleID: json['motorcycleID'] ?? '',
      borrowTimestamp: (json['borrowTimestamp'] as Timestamp).toDate(),
      nic: json['nic'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'active',
      returnDate: json['returnDate'] != null ? (json['returnDate'] as Timestamp).toDate() : null,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'motorcycleID': motorcycleID,
      'borrowTimestamp': Timestamp.fromDate(borrowTimestamp),
      'nic': nic,
      'name': name,
      'status': status,
      if (returnDate != null) 'returnDate': Timestamp.fromDate(returnDate!),
      'notes': notes,
    };
  }
}
