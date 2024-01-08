import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/provider/database_provider.dart';
import 'package:restaurant_app/app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/asset.dart';
import 'package:restaurant_app/app/views/restaurant_detail_view.dart';

class RestaurantListItem extends StatelessWidget {
  const RestaurantListItem({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
    required this.restaurant,
  });

  final double maxWidth;
  final double maxHeight;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RestaurantDetailProvider(
            apiService: ApiService(), restaurantId: restaurant.id);
        Navigator.pushNamed(
          context,
          RestaurantDetailView.routeName,
          arguments: restaurant.id,
        );
      },
      child: Consumer<DatabaseProvider>(
        builder: (context, state, _) => FutureBuilder(
            future: state.isFavorite(restaurant.id),
            builder: (context, snapshot) {
              bool isFavorite = snapshot.data ?? false;
              return Container(
                width: maxWidth,
                height: maxHeight / 8,
                margin: const EdgeInsets.only(top: marginSmall),
                decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(roundedLarge),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Row(
                  children: [
                    Hero(
                      tag: restaurant.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(roundedLarge),
                        child: CachedNetworkImage(
                          imageUrl: NetworkAsset.restaurantMediumRes +
                              restaurant.pictureId,
                          fit: BoxFit.cover,
                          width: maxWidth / 3,
                          height: maxWidth / 3,
                          errorWidget: (context, error, stackTrace) =>
                              const Icon(
                            Icons.error_outline_outlined,
                            color: errorColor,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: marginSmall),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                restaurant.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: openSansSemiBold.copyWith(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.place_rounded,
                                    size: 18.0,
                                    color: successColor,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    restaurant.city,
                                    style: openSansRegular,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rate_rounded,
                                    size: 18.0,
                                    color: secondaryLightColor,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${restaurant.rating}',
                                    style: openSansRegular,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isFavorite
                        ? IconButton(
                            icon: const Icon(Icons.favorite_rounded,
                                color: errorColor),
                            onPressed: () {
                              state.removeFavorite(restaurant.id, context);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.favorite_border_rounded,
                                color: errorColor),
                            onPressed: () {
                              state.addFavorite(restaurant, context);
                            },
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
