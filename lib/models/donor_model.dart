import 'package:milestone_1/models/donation_drive_model.dart';

class Donor {
  String name;
  double donation;
  String status;
  DonationDrive drive;

  Donor(this.name, this.donation, this.status, this.drive);
}
