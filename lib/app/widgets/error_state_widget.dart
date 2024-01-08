import 'package:flutter/material.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  const ErrorStateWidget({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    return SizedBox(
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
          const SizedBox(height: marginSmall),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: maxWidth / 2.4,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(roundedMedium),
                color: errorColor,
              ),
              child: Center(
                child: Text(
                  'Refresh',
                  style: openSansSemiBold.copyWith(color: whiteColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
