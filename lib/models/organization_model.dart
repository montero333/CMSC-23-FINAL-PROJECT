import '../models/donation_drive_model.dart';

class Organization {
  String name;
  double donation;
  List<DonationDrive> organizationDrives;
  String description;

  Organization(this.name, this.donation, this.organizationDrives, this.description);
}
