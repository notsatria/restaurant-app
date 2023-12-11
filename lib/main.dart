import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/views/home_view.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';

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
      initialRoute: HomeView.routeName,
      routes: {
        HomeView.routeName: (context) => const HomeView(),
        RestaurantDetailView.routeName: (context) => RestaurantDetailView(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
      },
    );
  }
}
