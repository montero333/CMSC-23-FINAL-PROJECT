
class Organization {
  String? id;
  String name;
  String? description;
  // List<String>? donations;
  bool status;

  Organization({
    this.id,
    required this.name,
    this.description,
    // required this.donations,
    required this.status,
  });

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'name': organization.name,
      'description': organization.description,
      'status': organization.status,
    };
  }

  static Organization fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}
