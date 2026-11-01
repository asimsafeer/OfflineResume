import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume_data.dart';

/// Saves the resume on the device so it survives app restarts.
class StorageService {
  static const _resumeKey = 'resume_v1';
  static const _exportCountKey = 'export_count';
  static const _reviewRequestedKey = 'review_requested';

  static Future<ResumeData?> loadResume() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_resumeKey);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return ResumeData.fromJson(Map<String, dynamic>.from(decoded));
    } catch (e) {
      debugPrint('Could not load saved resume: $e');
      return null;
    }
  }

  static Future<void> saveResume(ResumeData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_resumeKey, jsonEncode(data.toJson()));
    } catch (e) {
      debugPrint('Could not save resume: $e');
    }
  }

  static Future<void> clearResume() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resumeKey);
  }

  /// Counts a successful export and returns true when it's time to ask
  /// for a rating (on the 2nd export, once).
  static Future<bool> recordExportAndShouldAskReview() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_exportCountKey) ?? 0) + 1;
    await prefs.setInt(_exportCountKey, count);
    if (count >= 2 && !(prefs.getBool(_reviewRequestedKey) ?? false)) {
      await prefs.setBool(_reviewRequestedKey, true);
      return true;
    }
    return false;
  }
}
