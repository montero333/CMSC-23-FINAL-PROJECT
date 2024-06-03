
class Organization {
  String? id;
  String userId;
  String name;
  String? description;
  // List<String>? donations;
  bool status;

  Organization({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    // required this.donations,
    required this.status,
  });

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'userId': organization.userId,
      'name': organization.name,
      'description': organization.description,
      'status': organization.status,
    };
  }

  static Organization fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}
