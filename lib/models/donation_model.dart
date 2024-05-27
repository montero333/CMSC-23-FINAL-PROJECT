class Donation {
  String? id;
  String? driveID; //para saang donation drive yung donation
  String? userID; //sinong user nag donate
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
  String? image;
  String status;


  Donation({
    this.id,
    required this.driveID,
    required this.userID,
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
    this.image,
    this.status = "Pending"
  });

  // Factory constructor to create a Donation object from a JSON map
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      driveID: json['driveID'],
      userID: json['userID'],
      food: json['food'],
      clothes: json['clothes'],
      cash: json['cash'],
      necessities: json['necessities'],
      others: json['others'],
      deliveryMethod: json['deliveryMethod'],
      weight: json['weight'],
      addresses: json['addresses'],
      date: json['date'],
      time: json['time'],
      image: json['image'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'driveID': donation.driveID,
      'userID': donation.userID,
      'food': donation.food,
      'clothes': donation.clothes,
      'cash': donation.cash,
      'necessities': donation.necessities,
      'others': donation.others,
      'deliveryMethod': donation.deliveryMethod,
      'weight': donation.weight,
      'addresses': donation.addresses,
      'date': donation.date,
      'time': donation.time,
      'image': donation.image,
      'status': donation.status
    };
  }



  void printDetails() {
    print('Donation Details:');
    print('ID: ${id ?? 'N/A'}');
    print('Drive ID: $driveID'); 
    print('User ID: $userID'); 
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
    print('Status: $status');
  }

}