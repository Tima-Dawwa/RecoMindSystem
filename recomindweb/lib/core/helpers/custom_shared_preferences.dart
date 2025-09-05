import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class CustomSharedPreferences {
  static const _key = "token";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    if (kIsWeb) {
      html.window.localStorage.clear();
    }
  }

  Future<bool> logged() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.containsKey(_key) ||
        html.window.localStorage.toString() != '{}');
  }

  Future<bool> cleared() async {
    final prefs = await SharedPreferences.getInstance();
    return (!prefs.containsKey(_key) ||
        html.window.localStorage.toString() == '{}');
  }
}
