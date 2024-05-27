import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance{
  final String userId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;

  Attendance({
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkOut,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      userId: json['userId'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      checkIn: json['checkIn'] != null
          ? (json['checkIn'] as Timestamp).toDate()
          : null,
      checkOut: json['checkOut'] != null
          ? (json['checkOut'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'checkIn': checkIn != null ? Timestamp.fromDate(checkIn!) : null,
      'checkOut': checkOut != null ? Timestamp.fromDate(checkOut!) : null,
    };
  }
}
