import 'package:flutter/material.dart';
import 'package:restaurant_app/app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/app/provider/scheduling_provider.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;
  SchedulingProvider schedulingProvider;

  PreferencesProvider({
    required this.preferencesHelper,
    required this.schedulingProvider,
  }) {
    _getDailyReminder();
  }

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  void _getDailyReminder() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    debugPrint('getDailyReminder: $_isDailyReminderActive');
    if (_isDailyReminderActive) {
      schedulingProvider.scheduledRestaurants(true);
    }
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    debugPrint('enableDailyReminder: $value');
    preferencesHelper.setDailyReminder(value);
    schedulingProvider.scheduledRestaurants(value);
    _getDailyReminder();
  }
}
