import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/views/home_view.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/views/splash_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      initialRoute: SplashView.routeName,
      routes: {
        SplashView.routeName: (context) => const SplashView(),
        HomeView.routeName: (context) => const HomeView(),
        RestaurantDetailView.routeName: (context) => RestaurantDetailView(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
        SearchView.routeName: (context) =>  SearchView( restaurantList:               ModalRoute.of(context)?.settings.arguments as RestaurantList),
      },
    );
  }
}
