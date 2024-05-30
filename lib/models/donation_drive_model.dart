// lib/models/donation_drive.dart
class DonationDrive {
  String id;
  String title;
  String description;
  List<String>? imageUrls; // Changed imageUrl to List<String>

  DonationDrive({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrls,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls, // Changed imageUrl to imageUrls
    };
  }

  static DonationDrive fromMap(Map<String, dynamic> map) {
    return DonationDrive(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrls: map['imageUrls'] != null ? List<String>.from(map['imageUrls']) : null, // Changed imageUrl to imageUrls
    );
  }
}
