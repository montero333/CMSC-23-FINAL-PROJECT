// lib/models/donation_drive.dart
class DonationDrive {
  String id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  String? imageUrl;

  DonationDrive({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory DonationDrive.fromMap(Map<String, dynamic> map) {
    return DonationDrive(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      imageUrl: map['imageUrl'],
    );
  }
}
