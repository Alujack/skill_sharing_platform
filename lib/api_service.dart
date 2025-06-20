import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final http.Client client;
  final Connectivity connectivity;

  ApiService({
    http.Client? client,
    Connectivity? connectivity,
  })  : client = client ?? http.Client(),
        connectivity = connectivity ?? Connectivity();

  // Standard headers for JSON API
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String endpoint) async {
    return _makeRequest(
      () => client.get(
        Uri.parse(endpoint),
        headers: _headers,
      ),
    );
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    return _makeRequest(
      () => client.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    return _makeRequest(
      () => client.put(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
  }

  Future<dynamic> patch(String endpoint, {dynamic body}) async {
    return _makeRequest(
      () => client.patch(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
  }

  Future<dynamic> delete(String endpoint) async {
    return _makeRequest(
      () => client.delete(
        Uri.parse(endpoint),
        headers: _headers,
      ),
    );
  }

  Future<dynamic> _makeRequest(Future<http.Response> Function() request) async {
    // Check internet connection first
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw ApiException('No internet connection', 0);
    }

    try {
      final response = await request().timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timed out', 408);
    } on http.ClientException catch (e) {
      throw ApiException(e.message, 0);
    } catch (e) {
      throw ApiException('An unexpected error occurred', 0);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      final errorMessage = decoded['message'] ?? 
          decoded['error'] ?? 
          'Request failed with status ${response.statusCode}';
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  void dispose() {
    client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  var responseData;

  ApiException(this.message, this.statusCode, [response]);

  @override
  String toString() => 'ApiException: $message (Status $statusCode)';
}