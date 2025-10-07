import 'package:cloud_firestore/cloud_firestore.dart';

class Return {
  final String returnID;
  final String userID;
  final String motorcycleID;
  final DateTime returnTimestamp;
  final Map<String, double>? location; // {"lat": 12.34, "lng": 56.78} if navigation enabled
  final String motorcycleImageUrl;
  final String selfieImageUrl;

  Return({
    required this.returnID,
    required this.userID,
    required this.motorcycleID,
    required this.returnTimestamp,
    this.location,
    required this.motorcycleImageUrl,
    required this.selfieImageUrl,
  });

  factory Return.fromJson(Map<String, dynamic> json, String id) {
    return Return(
      returnID: id,
      userID: json['userID'] ?? '',
      motorcycleID: json['motorcycleID'] ?? '',
      returnTimestamp: (json['returnTimestamp'] as Timestamp).toDate(),
      location: json['location'] != null ? Map<String, double>.from(json['location']) : null,
      motorcycleImageUrl: json['motorcycle'] ?? '',
      selfieImageUrl: json['selfie'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'motorcycleID': motorcycleID,
      'returnTimestamp': Timestamp.fromDate(returnTimestamp),
      'location': location,
      'motorcycle': motorcycleImageUrl,
      'selfie': selfieImageUrl,
    };
  }
}
