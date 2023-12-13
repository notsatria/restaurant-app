import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late RestaurantList restaurantList;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Restoran',
                  style: openSansBold.copyWith(fontSize: 28),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SearchView.routeName,
                      arguments: restaurantList,
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: greyColor,
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text(
              'Rekomendasi restoran lokal favorit',
              style: openSansLight.copyWith(fontSize: 16),
            ),
            FutureBuilder<String>(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/local_restaurant.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorStateWidget(message: snapshot.error.toString());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  restaurantList = parseRestaurantList(snapshot.data);
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
