// lib/models/donation_drive.dart

class DonationDrive {
  String id;
  String title;
  String description;
  String? proofPhotoUrl;
  String orgID;

  DonationDrive({
    required this.id,
    required this.title,
    required this.description,
    this.proofPhotoUrl,
    required this.orgID
  });

  // Convert a DonationDrive object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': proofPhotoUrl,// Added donationIds
      'orgID':orgID
    };
  }

  // Create a DonationDrive object from a JSON map
  static DonationDrive fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      proofPhotoUrl: json['proofPhotoUrl'],
      orgID: json['orgID'],
    );
  }
}
