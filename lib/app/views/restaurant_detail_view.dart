import 'package:flutter/material.dart';
import 'package:restaurant_app/app/models/restaurant_list.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';

class RestaurantDetailView extends StatefulWidget {
  static const routeName = '/restaurant-detail-view';
  final Restaurant restaurant;
  const RestaurantDetailView({super.key, required this.restaurant});

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  bool isExpandedDescription = false;
  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverAppBar(
                expandedHeight: maxHeight / 4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: widget.restaurant.id,
                    child: Image.network(
                      widget.restaurant.pictureId,
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
                        widget.restaurant.name,
                        style: robotoBold.copyWith(fontSize: 18),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        '(',
                        style: robotoBold.copyWith(fontSize: 18),
                      ),
                      const Icon(
                        Icons.star_rate_rounded,
                        size: 20.0,
                        color: secondaryLightColor,
                      ),
                      Text(
                        '${widget.restaurant.rating})',
                        style: robotoBold.copyWith(fontSize: 18),
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
                        widget.restaurant.city,
                        style: robotoRegular.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: marginSmall),
                  const Divider(),
                  const SizedBox(height: marginSmall),
                  Text(
                    'Description',
                    style: robotoSemiBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: marginSmall),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpandedDescription = !isExpandedDescription;
                      });
                    },
                    child: Text(
                      widget.restaurant.description,
                      maxLines: isExpandedDescription ? 40 : 10,
                      overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: marginSmall),
                  const Divider(),
                  const SizedBox(height: marginSmall),
                  Text(
                    'Menu',
                    style: robotoSemiBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: marginSmall),
                  Text(
                    'Foods:',
                    style: robotoMedium.copyWith(fontSize: 14),
                  ),
                  Wrap(
                    children: widget.restaurant.menus.foods
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
                    style: robotoMedium.copyWith(fontSize: 14),
                  ),
                  Wrap(
                    children: widget.restaurant.menus.drinks
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
