import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/provider/preferences_provider.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // final schedulingProvider = Provider.of<SchedulingProvider>(context);
    return Consumer<PreferencesProvider>(
      builder: (context, state, _) => Scaffold(
          body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(marginLarge),
          children: [
            Text(
              'Settings',
              style: openSansBold.copyWith(fontSize: 28),
            ),
            const SizedBox(height: marginLarge),
            ListTile(
              title: Text('Notification', style: openSansSemiBold),
              subtitle: const Text('Enable/Disable notification'),
              trailing: Switch(
                value: state.isDailyReminderActive,
                onChanged: (value) {
                  state.enableDailyReminder(value);
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
