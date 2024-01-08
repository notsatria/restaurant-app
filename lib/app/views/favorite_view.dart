import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/provider/database_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/result_state.dart';
import 'package:restaurant_app/app/widgets/custom_loading_widget.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(marginLarge),
          children: [
            Text(
              'Restoran Favorit',
              style: openSansBold.copyWith(fontSize: 28),
            ),
            Text(
              'Restoran yang kamu sukai',
              style: openSansLight.copyWith(fontSize: 16),
            ),
            Consumer<DatabaseProvider>(builder: (context, state, _) {
              switch (state.state) {
                case ResultState.loading:
                  return const CustomLoadingWidget();
                case ResultState.hasData:
                  return Column(
                    children: state.favoriteRestaurants
                        .map((restaurant) => RestaurantListItem(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                              restaurant: restaurant,
                            ))
                        .toList(),
                  );
                case ResultState.noData:
                  return CustomEmptyView(
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    message: state.message,
                  );
                case ResultState.error:
                  return ErrorStateWidget(
                    message: state.message,
                    onTap: () {
                      state.refresh();
                    },
                  );
                default:
                  return CustomEmptyView(
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      message: state.message);
              }
            }),
          ],
        ),
      ),
    );
  }
}

class CustomEmptyView extends StatelessWidget {
  const CustomEmptyView({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    this.message = 'Anda belum memiliki restoran favorit',
  });

  final double maxHeight;
  final double maxWidth;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: maxHeight / 4),
      child: SizedBox(
        width: maxWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.fastfood_outlined,
              size: 100,
              color: errorColor,
            ),
            const SizedBox(height: marginSmall),
            Text(
              message,
              textAlign: TextAlign.center,
              style: openSansMedium,
            ),
            const SizedBox(height: marginSmall),
          ],
        ),
      ),
    );
  }
}
