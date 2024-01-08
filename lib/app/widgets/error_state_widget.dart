import 'package:flutter/material.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  const ErrorStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    double maxHeight = getMaxHeight(context);
    return SizedBox(
      height: maxHeight / 1.4,
      width: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 100,
            color: errorColor,
          ),
          const SizedBox(height: marginSmall),
          Text(
            message,
            textAlign: TextAlign.center,
            style: openSansMedium,
          ),
        ],
      ),
    );
  }
}
