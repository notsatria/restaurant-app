import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(marginLarge),
          children: [
            Text(
              'Restoran',
              style: robotoBold.copyWith(fontSize: 28),
            ),
            Text(
              'Rekomendasi restoran lokal favorit',
              style: robotoLight.copyWith(fontSize: 16),
            ),
            FutureBuilder<String>(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/local_restaurant.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final RestaurantList restaurantList =
                      parseRestaurantList(snapshot.data);
                  return Column(
                    children: restaurantList.restaurants
                        .map((restaurant) => RestaurantListItem(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                              restaurant: restaurant,
                            ))
                        .toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  RestaurantList parseRestaurantList(String? json) {
    if (json == null) return RestaurantList(restaurants: []);

    final Map<String, dynamic> parsedJson = jsonDecode(json);
    debugPrint('Parsed Json: $parsedJson');

    return RestaurantList.fromJson(parsedJson);
  }
}
