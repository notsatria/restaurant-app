import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/asset.dart';
import 'package:restaurant_app/app/widgets/custom_loading_widget.dart';
import 'package:restaurant_app/app/widgets/error_state_widget.dart';

class RestaurantDetailView extends StatelessWidget {
  static const routeName = '/restaurant-detail-view';
  final String restaurantId;
  const RestaurantDetailView({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    double maxHeight = getMaxHeight(context);
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(
          apiService: ApiService(), restaurantId: restaurantId),
      child: Scaffold(
        body: SafeArea(
          child:
              Consumer<RestaurantDetailProvider>(builder: (context, state, _) {
            switch (state.state) {
              case ResultState.loading:
                return const CustomLoadingWidget();
              case ResultState.hasData:
                return _buildRestaurantDetailView(state, maxHeight, context);
              case ResultState.error:
                return ErrorStateWidget(message: state.message);
              default:
                return ErrorStateWidget(message: state.message);
            }
          }),
        ),
      ),
    );
  }

  NestedScrollView _buildRestaurantDetailView(
      RestaurantDetailProvider state, double maxHeight, BuildContext context) {
    final restaurantDetailProvider =
        Provider.of<RestaurantDetailProvider>(context, listen: false);
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [
          SliverAppBar(
            expandedHeight: maxHeight / 4,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: state.restaurantDetail.id,
                child: Image.network(
                  NetworkAsset.restaurantLargeRes +
                      state.restaurantDetail.pictureId,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: whiteColor,
                shadows: [
                  Shadow(color: Colors.black38, blurRadius: 8.0),
                ],
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: marginLarge, vertical: marginMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    state.restaurantDetail.name,
                    style: openSansBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    '(',
                    style: openSansBold.copyWith(fontSize: 18),
                  ),
                  const Icon(
                    Icons.star_rate_rounded,
                    size: 20.0,
                    color: secondaryLightColor,
                  ),
                  Text(
                    '${state.restaurantDetail.rating})',
                    style: openSansBold.copyWith(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: marginSmall),
              Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    size: 20.0,
                    color: successColor,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    state.restaurantDetail.city,
                    style: openSansRegular.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: marginSmall),
              Row(
                children: [
                  const Icon(
                    Icons.map_rounded,
                    size: 20.0,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    state.restaurantDetail.address,
                    style: openSansRegular.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: marginSmall),
              const Divider(),
              const SizedBox(height: marginSmall),
              Text(
                'Description',
                style: openSansSemiBold.copyWith(fontSize: 16),
              ),
              const SizedBox(height: marginSmall),
              GestureDetector(
                onTap: () {
                  state.expandDescription();
                },
                child: Text(
                  state.restaurantDetail.description,
                  maxLines: state.isExpandedDescription ? 40 : 10,
                  overflow: TextOverflow.ellipsis,
                  style: openSansRegular.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(height: marginSmall),
              const Divider(),
              const SizedBox(height: marginSmall),
              Text(
                'Menu',
                style: openSansSemiBold.copyWith(fontSize: 16),
              ),
              const SizedBox(height: marginSmall),
              Text(
                'Foods:',
                style: openSansMedium.copyWith(fontSize: 14),
              ),
              Wrap(
                children: state.restaurantDetail.menus.foods
                    .map(
                      (food) => Container(
                        padding: const EdgeInsets.all(marginSmall),
                        margin: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(roundedLarge),
                          ),
                        ),
                        child: Text(food.name),
                      ),
                    )
                    .toList(),
              ),
              Text(
                'Drinks:',
                style: openSansMedium.copyWith(fontSize: 14),
              ),
              Wrap(
                children: state.restaurantDetail.menus.drinks
                    .map(
                      (drink) => Container(
                        padding: const EdgeInsets.all(marginSmall),
                        margin: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(roundedLarge),
                          ),
                        ),
                        child: Text(drink.name),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: marginSmall),
              const Divider(),
              const SizedBox(height: marginSmall),
              Text(
                'Reviews',
                style: openSansSemiBold.copyWith(fontSize: 16),
              ),
              const SizedBox(height: marginSmall),
              Column(
                children: state.restaurantDetail.customerReviews
                    .map(
                      (review) => _customerReviewItem(review),
                    )
                    .toList(),
              ),
              const SizedBox(height: marginSmall),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      controller:
                          restaurantDetailProvider.reviewEditingController,
                      onFieldSubmitted: (review) {
                        restaurantDetailProvider
                            .sendReview(
                              restaurantId: restaurantId,
                              name: 'Satria',
                              review: review,
                            )
                            .then((value) => restaurantDetailProvider
                                .reviewEditingController
                                .clear());
                      },
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                      style: openSansRegular.copyWith(
                          fontSize: 14, color: blackColor),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Tambahkan review',
                        hintStyle: openSansRegular.copyWith(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: marginSmall, horizontal: marginSmall),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(roundedLarge * 2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(roundedLarge * 2)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        restaurantDetailProvider
                            .sendReview(
                              restaurantId: restaurantId,
                              name: 'Satria',
                              review: restaurantDetailProvider
                                  .reviewEditingController.text,
                            )
                            .then((value) => restaurantDetailProvider
                                .reviewEditingController
                                .clear());
                      },
                      child: const CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _customerReviewItem(CustomerReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: marginSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: greyColor,
            child: Center(
              child: Icon(
                Icons.person,
                color: whiteColor,
              ),
            ),
          ),
          const SizedBox(width: marginSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${review.name} • ${review.date}',
                  style: openSansSemiBold.copyWith(fontSize: 12),
                ),
                Text(
                  review.review,
                  style: openSansMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
