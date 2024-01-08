import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/data/notifications/notification_helper.dart';
import 'package:restaurant_app/app/provider/restaurant_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/result_state.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';
import 'package:restaurant_app/app/views/search_view.dart';
import 'package:restaurant_app/app/widgets/custom_loading_widget.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    notificationHelper.pressNotification(RestaurantDetailView.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

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
                  return Padding(
                    padding: EdgeInsets.only(top: maxHeight / 4),
                    child: ErrorStateWidget(
                        message: state.message,
                        onTap: () {
                          state.fetchAllRestaurant();
                        }),
                  );
                case ResultState.error:
                  return Padding(
                    padding: EdgeInsets.only(top: maxHeight / 4),
                    child: ErrorStateWidget(
                        message: state.message,
                        onTap: () {
                          state.fetchAllRestaurant();
                        }),
                  );
                default:
                  return Padding(
                    padding: EdgeInsets.only(top: maxHeight / 4),
                    child: ErrorStateWidget(
                        message: state.message,
                        onTap: () {
                          state.fetchAllRestaurant();
                        }),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }
}
