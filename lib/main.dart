import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/database/database_helper.dart';
import 'package:restaurant_app/app/data/notifications/background_service.dart';
import 'package:restaurant_app/app/data/notifications/notification_helper.dart';
import 'package:restaurant_app/app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/app/provider/database_provider.dart';
import 'package:restaurant_app/app/provider/preferences_provider.dart';
import 'package:restaurant_app/app/provider/restaurant_provider.dart';
import 'package:restaurant_app/app/provider/scheduling_provider.dart';
import 'package:restaurant_app/app/provider/search_restaurant_provider.dart';
import 'package:restaurant_app/app/views/home_view.dart';
import 'package:restaurant_app/app/views/main_view.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/views/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<SearchRestaurantProvider>(
          create: (_) => SearchRestaurantProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
            schedulingProvider: SchedulingProvider(),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        initialRoute: SplashView.routeName,
        routes: {
          SplashView.routeName: (context) => const SplashView(),
          MainView.routeName: (context) => const MainView(),
          HomeView.routeName: (context) => const HomeView(),
          RestaurantDetailView.routeName: (context) => RestaurantDetailView(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String),
          SearchView.routeName: (context) => const SearchView(),
        },
      ),
    );
  }
}
