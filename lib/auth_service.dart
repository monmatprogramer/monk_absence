
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:presence_app/db_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final String _key = "token";
  var userData = {}.obs;
  var wholeData = {}.obs;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var messageUpdatePassword = ''.obs;
  var isSuccessfullUpdatePassword = false.obs;
  var userId = 0.obs;
  var isItImageDuplicate = false.obs;
  String role = '';
  void updateUserId(int value) => userId.value = value;
  Future<void> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("${DbConfig.apiUrl}/api/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, data[_key]);
      await prefs.setString('tokenCreatedAt', DateTime.now().toIso8601String());
      await getProfile();
      role = data['role'];
      updateUserId(data['id']);
      userData.addAll({'success': true, 'role': role});
    } else {
      userData.addAll({
        'success': false,
        'message': data['message'] ?? 'Failed to login',
      });
    }
  }

  Future<void> handleIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_key);
    final tokenTime = prefs.getString('tokenCreatedAt');
    if ([token, tokenTime].contains(null)) {
      isLoggedIn.value = false;
      return;
    }
    final DateTime createdAt = DateTime.parse(tokenTime!);
    final DateTime now = DateTime.now();
    final int diff = now.difference(createdAt).inDays;
    isLoggedIn.value = diff <= 7;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '';
  }

  Future<void> getProfile() async {
    final String token = await getToken();
    final uri = '${DbConfig.apiUrl}/api/user/profile';
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    try {
      final res = await http.get(Uri.parse(uri), headers: headers);
      if (res.statusCode == 200) {
        wholeData.value = jsonDecode(res.body);
        return;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching profile: $e");
    }
  }

  // Update password
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    isLoading.value = true;
    // Make sure the user is logged in
    final String token = await getToken();
    // API
    final uri = '${DbConfig.apiUrl}/api/user/change-password';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    try {
      final res = await http.put(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(body),
      );

      final message = jsonDecode(res.body);

      if (res.statusCode == 200) {
        isSuccessfullUpdatePassword.value = true;
        messageUpdatePassword.value = message['message'];
        isLoading.value = false;
      } else {
        isSuccessfullUpdatePassword.value = false;
        messageUpdatePassword.value = message['message'];
        isLoading.value = false;
      }
    } catch (e) {
      isSuccessfullUpdatePassword.value = false;
      debugPrint("🔥 Error updating password: $e");
    } finally {
      debugPrint("isSuccessfullUpdatePassword: $isSuccessfullUpdatePassword");
    }
  }

  Future<void> getProfileImage() async {
    await getProfile();
  }

  Future<bool> verifyUserImage() {
    // wholeData['profileImage']  /uploads/1754394116268-348854964.jpg
    print(" 👉👉 ${wholeData['profileImage']}" );
    return Future.value(isItImageDuplicate.value = false);
    
  }
}
