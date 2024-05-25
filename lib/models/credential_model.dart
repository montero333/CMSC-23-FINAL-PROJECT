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
    required this.userRole, // No default value
    this.organizationName, // Nullable field
    this.proofs, // Nullable field
    this.isApproved = false, // Default value for approval status
  });

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
      isApproved: json['isApproved'] ?? (json['userRole'] == 'Donor'), // Default value based on userRole
    );
  }

  static List<Credential> listFromJson(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Credential>((dynamic d) => Credential.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
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
