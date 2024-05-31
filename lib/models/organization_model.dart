import 'dart:convert';
import 'dart:io';

class Organization {
  String id;
  String name;
  String description;
  List<String>? donations;
  bool status;

  Organization({
    required this.id,
    required this.name,
    required this.description,
    required this.donations,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'donations': donations,
      'status': status,
    };
  }

  static Organization fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      donations: json['donations'] != null ? List<String>.from(json['donations']) : null,
      status: json['status'],
    );
  }
}
