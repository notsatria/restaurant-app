import 'package:flutter/material.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/fonts.dart';
import 'package:restaurant_app/app/theme/sizes.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Function()? onTap;

  final Function(String)? onChanged;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.prefixIcon = const Icon(Icons.search_rounded),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      style: openSansRegular.copyWith(fontSize: 14, color: blackColor),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: openSansRegular.copyWith(fontSize: 14),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
            vertical: marginSmall, horizontal: marginSmall),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedLarge * 2)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedLarge * 2)),
      ),
    );
  }
}
