import 'package:milestone_1/models/donation_drive_model.dart';

class Donation {
  String? id;
  DonationDrive drive; //para saang donation drive yung donation
  bool food;
  bool clothes;
  bool cash;
  bool necessities;
  bool others;
  String deliveryMethod;
  double weight;
  List addresses;
  String date;
  String time;


  Donation({
    this.id,
    required this.drive,
    required this.food,
    required this.clothes,
    required this.cash,
    required this.necessities,
    required this.others,
    required this.deliveryMethod,
    required this.weight,
    required this.addresses,
    required this.date,
    required this.time,
  });

  void printDetails() {
    print('Donation Details:');
    print('ID: ${id ?? 'N/A'}');
    print('Drive: ${drive.name}'); // Assuming DonationDrive has a 'name' attribute
    print('Food: $food');
    print('Clothes: $clothes');
    print('Cash: $cash');
    print('Necessities: $necessities');
    print('Others: $others');
    print('Delivery Method: $deliveryMethod');
    print('Weight: $weight kg');
    print('Addresses: ${addresses.join(', ')}');
    print('Date: $date');
    print('Time: $time');
  }

}