class Motorcycle {
  final String serialNumber;
  final String model;
  final String productSeries;
  final String ownerID;
  final String borrowStatus; // "available" or "in use"
  final String returnStatus; // "returned" or "not returned"
  final String location; // Added for compatibility

  Motorcycle({
    required this.serialNumber,
    required this.model,
    required this.productSeries,
    required this.ownerID,
    required this.borrowStatus,
    required this.returnStatus,
    required this.location,
  });

  factory Motorcycle.fromJson(Map<String, dynamic> json, String id) {
    return Motorcycle(
      serialNumber: id,
      model: json['model'] ?? '',
      productSeries: json['productSeries'] ?? '',
      ownerID: json['ownerID'] ?? '',
      borrowStatus: json['borrowStatus'] ?? 'available',
      returnStatus: json['returnStatus'] ?? 'not returned',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'productSeries': productSeries,
      'ownerID': ownerID,
      'borrowStatus': borrowStatus,
      'returnStatus': returnStatus,
      'location': location,
    };
  }
}
