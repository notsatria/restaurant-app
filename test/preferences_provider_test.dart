import 'package:flutter/material.dart';
import 'package:restaurant_app/app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/app/provider/preferences_provider.dart';
import 'package:restaurant_app/app/provider/scheduling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('Preferences Provider test', () {
    test('Test scheduledRestaurants function on Scheduling Provider', () {
      PreferencesProvider preferencesProvider = PreferencesProvider(
          preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance()),
          schedulingProvider: SchedulingProvider());
      SchedulingProvider schedulingProvider = SchedulingProvider();
      preferencesProvider.enableDailyReminder(true);
      expect(schedulingProvider.isScheduled, true);
    });
  });
}
