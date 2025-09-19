import 'package:flutter_test/flutter_test.dart';
import 'package:gocheck/models/scooter.dart';

void main() {
  group('Scooter Model', () {
    test('fromJson creates Scooter correctly', () {
      final json = {
        'plate': 'B1234ABC',
        'model': 'Honda Beat',
        'owner': 'John Doe',
        'location': 'Malang',
        'status': 'Available',
        'imageUrl': 'https://example.com/image.png',
      };

      final scooter = Scooter.fromJson(json, 'id123');

      expect(scooter.id, 'id123');
      expect(scooter.plate, 'B1234ABC');
      expect(scooter.model, 'Honda Beat');
      expect(scooter.owner, 'John Doe');
      expect(scooter.location, 'Malang');
      expect(scooter.status, 'Available');
      expect(scooter.imageUrl, 'https://example.com/image.png');
    });

    test('toJson returns correct map', () {
      final scooter = Scooter(
        id: 'id123',
        plate: 'B1234ABC',
        model: 'Honda Beat',
        owner: 'John Doe',
        location: 'Malang',
        status: 'Available',
        imageUrl: 'https://example.com/image.png',
      );

      final json = scooter.toJson();

      expect(json['plate'], 'B1234ABC');
      expect(json['model'], 'Honda Beat');
      expect(json['owner'], 'John Doe');
      expect(json['location'], 'Malang');
      expect(json['status'], 'Available');
    });
  });
}
