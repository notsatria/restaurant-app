import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  late String restaurantId;

  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    getRestaurantDetailById(restaurantId);
  }

// VARIABLES
  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';
  bool _isExpandedDescription = false;
  // List<CustomerReview> _customerReviews = [];

  TextEditingController reviewEditingController = TextEditingController();

  // END OF VARIABLES

  // START OF GETTERS
  String get message => _message;

  RestaurantDetail get restaurantDetail => _restaurantDetail;

  ResultState get state => _state;

  bool get isExpandedDescription => _isExpandedDescription;

  // List<CustomerReview> get customerReviews => _customerReviews;
  // END OF GETTERS

  Future<dynamic> getRestaurantDetailById(String restaurantId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail =
          await apiService.getRestaurantDetail(restaurantId);

      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantDetail = restaurantDetail;
    } catch (e) {
      print('Error on getRestaurantDetailById --> $e');
      if (e is SocketException) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Tidak Ada Koneksi Internet';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Terjadi Kesalahan Saat Mencari Restoran';
      }
    }
  }

  void expandDescription() {
    _isExpandedDescription = !_isExpandedDescription;
    notifyListeners();
  }

  String formatDate(DateTime dateTime) {
    final format = DateFormat('d MMMM y', 'en_US');
    return format.format(dateTime);
  }

  Future<dynamic> sendReview(
      {required String restaurantId,
      required String name,
      required String review}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await apiService.postReview(
          restaurantId: restaurantId, name: name, review: review);

      _state = ResultState.hasData;

      _restaurantDetail.customerReviews.add(CustomerReview(
        name: name,
        review: review,
        date: formatDate(DateTime.now()),
      ));
      notifyListeners();
      // return _customerReviews = customerReviews;
    } catch (e) {
      print('Error on sendReview --> $e');
      if (e is SocketException) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Tidak Ada Koneksi Internet';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Terjadi Kesalahan Saat Post Review';
      }
    }
  }
}
