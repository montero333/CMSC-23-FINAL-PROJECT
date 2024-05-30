import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/organization_model.dart';

class OrganizationApi {
  static const String baseUrl = 'https://example.com/api'; // Replace with your API URL

  Future<List<Organization>> fetchOrganizations() async {
    final response = await http.get(Uri.parse('$baseUrl/organizations'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Organization.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  Future<Organization> createOrganization(Organization organization) async {
    final response = await http.post(
      Uri.parse('$baseUrl/organizations'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(organization.toMap()),
    );

    if (response.statusCode == 201) {
      return Organization.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create organization');
    }
  }

  Future<Organization> updateOrganization(Organization organization) async {
    final response = await http.put(
      Uri.parse('$baseUrl/organizations/${organization.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(organization.toMap()),
    );

    if (response.statusCode == 200) {
      return Organization.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update organization');
    }
  }

  Future<void> deleteOrganization(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/organizations/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete organization');
    }
  }
}
