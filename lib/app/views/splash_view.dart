import 'package:flutter/material.dart';
import 'package:restaurant_app/app/theme/colors.dart';
import 'package:restaurant_app/app/theme/sizes.dart';
import 'package:restaurant_app/app/utils/asset.dart';
import 'package:restaurant_app/app/views/main_view.dart';

class SplashView extends StatefulWidget {
  static const routeName = '/splash-view';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, MainView.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = getMaxWidth(context);
    return Scaffold(
      backgroundColor: secondaryLightColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            LocalAsset.splash,
            width: maxWidth / 2,
          ),
        ),
      ),
    );
  }
}
