import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/provider/restaurant_provider.dart';
import 'package:restaurant_app/app/provider/search_restaurant_provider.dart';
import 'package:restaurant_app/app/views/home_view.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
