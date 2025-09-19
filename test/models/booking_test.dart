import 'package:flutter_test/flutter_test.dart';
import 'package:gocheck/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Booking Model', () {
    test('fromJson creates Booking correctly', () {
      final timestamp = Timestamp.now();
      final json = {
        'id': 'booking123',
        'userId': 'user123',
        'scooterId': 'scooter123',
        'status': 'Active',
        'borrowDate': timestamp,
        'returnDate': null,
        'notes': 'Test note',
      };

      final booking = Booking.fromJson(json, 'booking123');

      expect(booking.id, 'booking123');
      expect(booking.userId, 'user123');
      expect(booking.scooterId, 'scooter123');
      expect(booking.status, 'Active');
      expect(booking.borrowDate, timestamp.toDate());
      expect(booking.returnDate, null);
      expect(booking.notes, 'Test note');
    });

    test('toJson returns correct map', () {
      final now = DateTime.now();
      final booking = Booking(
        id: 'booking123',
        userId: 'user123',
        scooterId: 'scooter123',
        status: 'Active',
        borrowDate: now,
        returnDate: null,
        notes: 'Test note',
      );

      final json = booking.toJson();

      expect(json['id'], 'booking123');
      expect(json['userId'], 'user123');
      expect(json['scooterId'], 'scooter123');
      expect(json['status'], 'Active');
      expect(json['borrowDate'], isA<Timestamp>());
      expect(json['returnDate'], null);
      expect(json['notes'], 'Test note');
    });
  });
}
