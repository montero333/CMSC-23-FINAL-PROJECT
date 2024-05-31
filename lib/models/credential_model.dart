import 'dart:convert';

class Credential {
  String userId;
  String email;
  String firstName;
  String lastName;
  String passWord;
  String address;
  String contactNumber;
  String userRole;
  String? organizationName;
  String? proofs;
  bool isApproved;

  Credential({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.passWord,
    required this.address,
    required this.contactNumber,
    required this.userRole,
    this.organizationName,
    this.proofs,
    this.isApproved = false,
  }) {
    // Ensure isApproved is true if the userRole is 'Donor'
    if (userRole == 'Donor') {
      isApproved = true;
    }
  }

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      userId: json['userId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      passWord: json['passWord'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      userRole: json['userRole'] ?? 'Donor',
      organizationName: json['organizationName'],
      proofs: json['proofs'],
      isApproved: json['isApproved'] ?? (json['userRole'] == 'Donor'),
    );
  }

  static List<Credential> listFromJson(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Credential>((dynamic d) => Credential.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    // Ensure isApproved is true if the userRole is 'Donor' before converting to JSON
    if (userRole == 'Donor') {
      isApproved = true;
    }
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'passWord': passWord,
      'address': address,
      'contactNumber': contactNumber,
      'userRole': userRole,
      'organizationName': organizationName,
      'proofs': proofs,
      'isApproved': isApproved,
    };
  }
}
