import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://0ju0jnq5kk.execute-api.us-east-1.amazonaws.com';

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  static Future<void> trackProduct({
    required String userId,
    required String productId,
  }) async {
    final url = Uri.parse('$baseUrl/track');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'productId': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to track product');
    }
  }

  static Future<List<dynamic>> getTrackedProducts({
    required String userId,
  }) async {
    final url = Uri.parse('$baseUrl/tracked?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load tracked products');
    }
  }
}
