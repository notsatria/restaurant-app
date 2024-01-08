import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const dailyRemainder = 'DAILY_REMINDER';

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyRemainder) ?? false;
  }

  void setDailyReminder(bool value) async {
    debugPrint('setDailyReminder: $value');
    final prefs = await sharedPreferences;
    prefs.setBool(dailyRemainder, value);
  }
}
