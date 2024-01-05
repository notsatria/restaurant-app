import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/provider/restaurant_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/widgets/custom_loading_widget.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';

class HomeView extends StatelessWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});

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
            Consumer<RestaurantProvider>(builder: (context, state, _) {
              switch (state.state) {
                case ResultState.loading:
                  return const CustomLoadingWidget();
                case ResultState.hasData:
                  return Column(
                    children: state.restaurantList
                        .map(
                          (restaurant) => RestaurantListItem(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                              restaurant: restaurant),
                        )
                        .toList(),
                  );
                case ResultState.noData:
                  return ErrorStateWidget(message: state.message);
                case ResultState.error:
                  return ErrorStateWidget(message: state.message);
                default:
                  return ErrorStateWidget(message: state.message);
              }
            }),
          ],
        ),
      ),
    );
  }
}
