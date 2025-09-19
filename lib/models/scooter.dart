class Scooter {
  final String id;
  final String plate;
  final String model;
  final String owner;
  final String location;
  final String status; // Available, In Use, etc.
  final String imageUrl;

  Scooter({
    required this.id,
    required this.plate,
    required this.model,
    required this.owner,
    required this.location,
    required this.status,
    required this.imageUrl,
  });

  factory Scooter.fromJson(Map<String, dynamic> json, String id) {
    return Scooter(
      id: id,
      plate: json['plate'] ?? '',
      model: json['model'] ?? '',
      owner: json['owner'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'Available',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'model': model,
      'owner': owner,
      'location': location,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}
