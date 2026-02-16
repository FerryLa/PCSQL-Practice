import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  final String? authToken;

  ApiClient({http.Client? client, this.authToken})
      : _client = client ?? http.Client();

  /// GitHub Raw Content 가져오기
  Future<String> fetchRawContent(String path) async {
    final url = ApiConstants.rawContentUrl(path);
    final response = await _get(url);
    return response.body;
  }

  /// GitHub API 호출 (JSON)
  Future<Map<String, dynamic>> fetchApiJson(String url) async {
    final response = await _get(url, isApi: true);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// GitHub API 리스트 호출
  Future<List<dynamic>> fetchApiList(String url) async {
    final response = await _get(url, isApi: true);
    return json.decode(response.body) as List<dynamic>;
  }

  Future<http.Response> _get(String url, {bool isApi = false}) async {
    final headers = <String, String>{};
    if (isApi) {
      headers['Accept'] = 'application/vnd.github.v3+json';
    }
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await _client.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 403) {
      final remaining = response.headers['x-ratelimit-remaining'];
      if (remaining == '0') {
        throw RateLimitException(
          resetTime: response.headers['x-ratelimit-reset'],
        );
      }
    }

    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'API request failed: ${response.statusCode}',
      );
    }

    return response;
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class RateLimitException implements Exception {
  final String? resetTime;

  const RateLimitException({this.resetTime});

  @override
  String toString() => 'RateLimitException: Rate limit exceeded. Reset: $resetTime';
}
