import 'dart:convert';

class Credential {

  String userName;
  String firstName;
  String lastName;
  String passWord;
  String address;       
  String contactNumber; 
  String userRole;      

  Credential
  (
    {
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.passWord,
      required this.address,       
      required this.contactNumber, 
      this.userRole = 'Donors'     // Default value
    }
  );

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential
    (
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      passWord: json['passWord'],
      address: json['address'],           
      contactNumber: json['contactNumber'], 
      userRole: json['userRole'] ?? 'Donors' // Default value if null
    );
  }

  static List<Credential> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Credential>((dynamic d) => Credential.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Credential c) {
    return {
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'passWord': passWord,
      'address': address,             
      'contactNumber': contactNumber, 
      'userRole': userRole            
    };
  }
}
