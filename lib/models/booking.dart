import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String scooterId;
  final String status; // Active, Returned, etc.
  final DateTime borrowDate;
  final DateTime? returnDate;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.scooterId,
    required this.status,
    required this.borrowDate,
    this.returnDate,
    this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json, [String? id]) {
    return Booking(
      id: id ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      scooterId: json['scooterId'] ?? '',
      status: json['status'] ?? 'Active',
      borrowDate: (json['borrowDate'] as Timestamp).toDate(),
      returnDate: json['returnDate'] != null ? (json['returnDate'] as Timestamp).toDate() : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'scooterId': scooterId,
      'status': status,
      'borrowDate': Timestamp.fromDate(borrowDate),
      'returnDate': returnDate != null ? Timestamp.fromDate(returnDate!) : null,
      'notes': notes,
    };
  }
}
