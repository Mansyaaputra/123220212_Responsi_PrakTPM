import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class ApiService {
  final String baseUrl = 'https://resp-api-three.vercel.app';

  
  Future<List<Phone>> fetchPhones() async {
    final response = await http.get(Uri.parse('$baseUrl/phones'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];

      final phones = data.map((item) => Phone.fromJson(item)).toList();
      print('dataphone: $phones');
      return phones;
    } else {
      throw Exception('Failed to fetch phones');
    }
  }

  Future<Phone> fetchPhoneById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/phone/$id'));
    if (response.statusCode == 200) {
      return Phone.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch phone by ID');
    }
  }

  Future<void> addPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add phone');
    }
  }


  Future<void> updatePhone(int id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phone/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update phone');
    }
  }

  Future<void> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phone/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete phone');
    }
  }
}
