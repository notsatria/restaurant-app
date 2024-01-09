import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/provider/search_restaurant_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/result_state.dart';
import 'package:restaurant_app/app/widgets/custom_loading_widget.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';
import 'package:restaurant_app/app/widgets/restaurant_list_item.dart';
import 'package:restaurant_app/app/widgets/search_text_field.dart';

class SearchView extends StatelessWidget {
  static const routeName = '/search-view';
  const SearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    final searchRestaurantProvider =
        Provider.of<SearchRestaurantProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: SearchTextField(
          controller: searchRestaurantProvider.searchTextController,
          hintText: 'Cari Restoran',
          onChanged: (query) {
            searchRestaurantProvider.searchRestaurant(query.toLowerCase());
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
          switch (state.state) {
            case ResultState.loading:
              return const CustomLoadingWidget();
            case ResultState.noData:
              return Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 100,
                      color: errorColor,
                    ),
                    const SizedBox(height: marginSmall),
                    SizedBox(
                      width: maxWidth / 1.5,
                      child: const Center(
                        child: Text('Data pencarian belum ditemukan'),
                      ),
                    ),
                  ],
                ),
              );
            case ResultState.hasData:
              return ListView(
                padding: const EdgeInsets.all(marginLarge),
                children: state.searchResult
                    .map(
                      (restaurant) => RestaurantListItem(
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          restaurant: restaurant),
                    )
                    .toList(),
              );
            case ResultState.error:
              return ErrorStateWidget(
                message: state.message,
              );
            case ResultState.noData:
              return ErrorStateWidget(message: state.message);
            default:
              return ErrorStateWidget(message: state.message);
          }
        }),
      ),
    );
  }
}
