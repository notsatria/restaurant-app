import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';
import 'package:restaurant_app/app/widgets/search_text_field.dart';

class SearchView extends StatefulWidget {
  static const routeName = '/search-view';
  final RestaurantList restaurantList;
  const SearchView({super.key, required this.restaurantList});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchTextController = TextEditingController();
  List<Restaurant> searchResult = [];
  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: SearchTextField(
          controller: searchTextController,
          hintText: 'Cari Restoran',
          onChanged: (value) {
            setState(() {
              searchResult = filterRestaurants(value);
            });
          },
        ),
      ),
      body: SafeArea(
        child: searchResult.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 100,
                      color: errorColor,
                    ),
                    SizedBox(height: marginSmall),
                    Text('Data pencarian belum ditemukan'),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(marginLarge),
                children: searchResult
                    .map(
                      (restaurant) => RestaurantListItem(
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          restaurant: restaurant),
                    )
                    .toList(),
              ),
      ),
    );
  }

  List<Restaurant> filterRestaurants(String value) {
    return widget.restaurantList.restaurants
        .where(
          (restaurant) => restaurant.name.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();
  }
}
