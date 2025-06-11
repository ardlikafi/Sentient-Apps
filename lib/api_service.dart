import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ApiService {
  // Konfigurasi server
  static const String serverIP =
      '192.168.110.40'; // Sesuaikan dengan IP server Anda
  static const int serverPort = 8000;
  static const String baseUrl = 'http://$serverIP:$serverPort/api';

  static Future<Map<String, dynamic>?> register({
    required String username,
    required String email,
    required String password,
    File? avatar,
  }) async {
    var uri = Uri.parse('$baseUrl/register');
    var request = http.MultipartRequest('POST', uri);
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    if (avatar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatar.path),
      );
    }
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Register failed with status: \\${response.statusCode}');
        print('Response body: \\${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during register: \\${e}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Get profile failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during get profile: $e');
      return null;
    }
  }

  static Future<String?> uploadAvatar({
    required String token,
    required File avatar,
  }) async {
    var uri = Uri.parse('$baseUrl/profile/avatar');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['profile']?['avatar'];
      } else {
        print('Upload avatar failed: \\${response.statusCode}');
        print('Response body: \\${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during upload avatar: \\${e}');
      return null;
    }
  }
}