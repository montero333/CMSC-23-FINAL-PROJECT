import 'dart:convert';

class Credential {
  String userName;
  String firstName;
  String lastName;
  String passWord;
  String address;
  String contactNumber;
  String userRole;
  String? organizationName; // Nullable field for organization name
  String? proofs; // Nullable field for proofs of legitimacy
  bool isApproved; // Added field for approval status

  Credential({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.passWord,
    required this.address,
    required this.contactNumber,
    required this.userRole, // No default value
    this.organizationName, // Nullable field
    this.proofs, // Nullable field
    bool? isApproved, // Nullable field
  }) : isApproved = isApproved ?? (userRole == 'Donor'); // Default value based on userRole

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      passWord: json['passWord'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      userRole: json['userRole'] ?? 'Donor', // Default value if null
      organizationName: json['organizationName'], // Nullable field
      proofs: json['proofs'], // Nullable field
      isApproved: json['isApproved'] ?? (json['userRole'] == 'Donor'), // Default value based on userRole
    );
  }

  static List<Credential> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Credential>((dynamic d) => Credential.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'passWord': passWord,
      'address': address,
      'contactNumber': contactNumber,
      'userRole': userRole,
      'organizationName': organizationName, // Nullable field
      'proofs': proofs, // Nullable field
      'isApproved': isApproved, // Approval status
    };
  }
}
