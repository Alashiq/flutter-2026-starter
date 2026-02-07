import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:starter/core/env/env.dart';
import 'package:starter/features/auth/auth_controller.dart';

class ApiClient {
  final Env _env = Get.find<Env>();

  // Helper to get headers
  Map<String, String> _getHeaders({bool auth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      // Check if AuthController is registered to avoid errors in early stages
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();
        final token = authController.token;
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }
    }
    return headers;
  }

  // Construct full URL
  Uri _getUri(String path) {
    // Remove leading slash if present to avoid double slashes with baseUrl which might have trailing slash
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final baseUrl = _env.baseUrl.endsWith('/')
        ? _env.baseUrl
        : '${_env.baseUrl}/';
    return Uri.parse('$baseUrl$cleanPath');
  }

  // GET Request (Public)
  Future<http.Response> get(String path) async {
    final uri = _getUri(path);
    return await http.get(uri, headers: _getHeaders(auth: false));
  }

  // GET Request (Authenticated)
  Future<http.Response> getAuth(String path) async {
    final uri = _getUri(path);
    return await http.get(uri, headers: _getHeaders(auth: true));
  }

  // POST Request (Public)
  Future<http.Response> post(String path, {dynamic body}) async {
    final uri = _getUri(path);
    return await http.post(
      uri,
      body: jsonEncode(body),
      headers: _getHeaders(auth: false),
    );
  }

  // POST Request (Authenticated)
  Future<http.Response> postAuth(String path, {dynamic body}) async {
    final uri = _getUri(path);
    return await http.post(
      uri,
      body: jsonEncode(body),
      headers: _getHeaders(auth: true),
    );
  }

  // PUT Request (Public)
  Future<http.Response> put(String path, {dynamic body}) async {
    final uri = _getUri(path);
    return await http.put(
      uri,
      body: jsonEncode(body),
      headers: _getHeaders(auth: false),
    );
  }

  // PUT Request (Authenticated)
  Future<http.Response> putAuth(String path, {dynamic body}) async {
    final uri = _getUri(path);
    return await http.put(
      uri,
      body: jsonEncode(body),
      headers: _getHeaders(auth: true),
    );
  }

  // DELETE Request (Public)
  Future<http.Response> delete(String path) async {
    final uri = _getUri(path);
    return await http.delete(uri, headers: _getHeaders(auth: false));
  }

  // DELETE Request (Authenticated)
  Future<http.Response> deleteAuth(String path) async {
    final uri = _getUri(path);
    return await http.delete(uri, headers: _getHeaders(auth: true));
  }
}
