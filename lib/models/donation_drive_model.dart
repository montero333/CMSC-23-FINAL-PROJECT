import '../models/donor_model.dart';

class DonationDrive {
  String title;
  String description;
  List<Donor> donors;

  DonationDrive(this.title, this.description, [List<Donor>? donors])
      : donors = donors ?? [];

  void addDonor(Donor donor) {
    donors.add(donor);
  }

  double get totalDonations {
    return donors.fold(0.0, (sum, donor) => sum + donor.donation);
  }
}
