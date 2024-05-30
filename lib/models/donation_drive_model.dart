// lib/models/donation_drive.dart
import 'dart:io';

class DonationDrive {
  String id;
  String title;
  String description;
  String? proofPhotoUrl;
  List<String>? donationIds; // Added list of donation IDs

  DonationDrive({
    required this.id,
    required this.title,
    required this.description,
    this.proofPhotoUrl,
    this.donationIds, String? imageUrl,
  });

  // Convert a DonationDrive object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': proofPhotoUrl,
      'donationIds': donationIds, // Added donationIds
    };
  }

  // Create a DonationDrive object from a JSON map
  static DonationDrive fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      proofPhotoUrl: json['proofPhotoUrl'],
      donationIds: json['donationIds'] != null ? List<String>.from(json['donationIds']) : null, // Added donationIds
    );
  }
}
