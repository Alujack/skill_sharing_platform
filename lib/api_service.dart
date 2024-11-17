import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // GET request
  Future<http.Response> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("GET Success: ${response.body}");
    } else {
      print("GET Error: ${response.statusCode}");
    }
    return response;
  }

  // POST request
  Future<http.Response> postData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print("POST Success: ${response.body}");
    } else {
      print("POST Error: ${response.statusCode}");
    }
    return response;
  }

  // PUT request
  Future<http.Response> putData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("PUT Success: ${response.body}");
    } else {
      print("PUT Error: ${response.statusCode}");
    }
    return response;
  }

  // DELETE request
  Future<http.Response> deleteData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("DELETE Success: ${response.body}");
    } else {
      print("DELETE Error: ${response.statusCode}");
    }
    return response;
  }
}
