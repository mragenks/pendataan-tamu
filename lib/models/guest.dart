class Guest {
  final int? id;
  final String name;
  final String plateNumber;
  final String purpose;
  final DateTime checkInTime;
  final DateTime? checkOutTime;

  Guest({
    this.id,
    required this.name,
    required this.plateNumber,
    required this.purpose,
    required this.checkInTime,
    this.checkOutTime,
  });

  // Konversi untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'plateNumber': plateNumber,
      'purpose': purpose,
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
    };
  }
}
