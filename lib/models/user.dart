class User {
  final String id; // Document ID (serves as both id and nik)
  final String name;
  final String position;
  final String? email; // For auth purposes
  final String? phone; // For auth purposes

  // Getter for nik to maintain backward compatibility
  String get nik => id;

  User({
    required this.id,
    required this.name,
    required this.position,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      // Include email and phone if present, but schema doesn't require them
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }
}
