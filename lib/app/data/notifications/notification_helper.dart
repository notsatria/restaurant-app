import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/app/utils/asset.dart';
import 'package:restaurant_app/app/utils/navigation.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String?>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "restaurant channel";

    var bigPicturePath = await _downloadAndSaveFile(
        NetworkAsset.restaurantMediumRes + restaurant.pictureId, 'bigPicture');

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      contentTitle: restaurant.name,
      htmlFormatContentTitle: true,
      summaryText: restaurant.description,
      htmlFormatSummaryText: true,
    );

    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            // styleInformation: const DefaultStyleInformation(true, true));
            styleInformation: bigPictureStyleInformation);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "Restaurant Recommendation";
    var titleRestaurantName = restaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurantName, platformChannelSpecifics,
        payload: json.encode(restaurant.toJson()));
  }

  void pressNotification(String route) {
    selectNotificationSubject.stream.listen(
      (String? payload) async {
        var restaurant = Restaurant.fromJson(json.decode(payload!));
        var restaurantId = restaurant.id;
        RestaurantDetailProvider(
            apiService: ApiService(), restaurantId: restaurant.id);
        Navigation.intentWithData(route, restaurantId);
      },
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
