import 'package:intl/intl.dart';

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

  // Helper methods untuk format datetime
  String get formattedCheckInTime {
    final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(checkInTime.toLocal());
  }

  String get formattedCheckOutTime {
    if (checkOutTime == null) return 'Not checked out';
    final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm');
    return formatter.format(checkOutTime!.toLocal());
  }

  // Format untuk tampilan singkat (hanya jam)
  String get shortCheckInTime {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(checkInTime.toLocal());
  }

  // Format untuk tanggal saja
  String get checkInDate {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(checkInTime.toLocal());
  }

  // Method yang sudah ada
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