import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  static const String baseUrl = 'https://dragonball-api.com/api';

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: params);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Error ${response.statusCode}: ${response.body}');
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());