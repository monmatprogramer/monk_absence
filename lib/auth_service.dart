import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:presence_app/db_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final String _key = "token";
  final String _userIdKey = "id";
  var userData = {}.obs;
  var wholeData = {}.obs;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var messageUpdatePassword = ''.obs;
  var isSuccessfullUpdatePassword = false.obs;
  var userId = 0.obs;
  var isItImageDuplicate = false.obs;
  String role = '';
  var logger = Logger(printer: PrettyPrinter());

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt(_userIdKey) ?? 0;
  }

  void updateUserId(int value) => userId.value = value;
  Future<void> login(String username, String password) async {
    isLoading.value = true;
    //clear any previous user data to avoid duplication
    userData.clear();
    try {
      //validation input fields
      if (username.trim().isEmpty || password.trim().isEmpty) {
        userData.addAll({
          'success': false,
          'message': 'Username and password cannot be empty',
        });
        return;
      }

      //login request
      final res = await http
          .post(
            Uri.parse("${DbConfig.apiUrl}/api/auth/login"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                'Connection timeout - please check your internet connection and try again.!!!',
                const Duration(seconds: 5),
              );
            },
          );

      final data = jsonDecode(res.body);
      updateUserId(data['id']);

      logger.d("data in authService: $data");

      if (res.statusCode == 200) {
        // Valid credetial response
        if (data[_key] == null || data['role'] == null || data['id'] == null) {
          userData.addAll({
            'success': false,
            'message': 'Invalid server response - missing required fields',
          });
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_key, data[_key]);
        await prefs.setInt(_userIdKey, data['id']);
        await prefs.setString(
          'tokenCreatedAt',
          DateTime.now().toIso8601String(),
        );
        await getProfile();
        role = data['role'];

        userData.addAll({'success': true, 'role': role, 'id': data['id']});
      } else if (res.statusCode == 401) {
        //Handle unauthorized access
        userData.addAll({
          'success': false,
          'message': 'Invalid username or password',
        });
      } else if (res.statusCode >= 500) {
        //Handle server errors
        userData.addAll({
          'success': false,
          'message': 'Failed to connect to server',
        });
      } else {
        userData.addAll({
          'success': false,
          'message': data['message'] ?? 'Failed to login',
        });
      }
    } on TimeoutException catch (e) {
      // Handle network errors
      userData.addAll({
        'success': false,
        'message':
            e.message ??
            'Connection timeout - please check your internet connection and try again.!!!',
      });
    } on http.ClientException catch (e) {
      userData.addAll({
        'success': false,
        'message':
            'Network error - please check your internet connection and try again.!!!',
      });
    } on FormatException catch (e) {
      userData.addAll({
        'success': false,
        'message': 'Invalid server response format',
      });
    } catch (e) {
      userData.addAll({
        'success': false,
        'message': 'An unexpected error occurred. Please try again later.',
      });
    } finally {
      isLoading.value = false;
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
    userId.value = 0;
    isLoading.value = false;
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

  //Get only user id
  Future<void> getUserId() async {
    final String token = await getToken();
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
    print(" 👉👉 ${wholeData['profileImage']}");
    return Future.value(isItImageDuplicate.value = false);
  }
}
