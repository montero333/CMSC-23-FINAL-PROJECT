import 'donation_drive_model.dart';

class Organization {
  String id;
  String name;
  String description;
  List<DonationDrive> donationDrives;
  bool status;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.donationDrives,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'donationDrives': donationDrives.map((drive) => drive.toJson()).toList(),
      'status': status,
    };
  }

  static Organization fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      donationDrives: List<DonationDrive>.from(map['donationDrives']?.map((drive) => DonationDrive.fromJson(drive)) ?? []),
      status: map['status'],
    );
  }
}
