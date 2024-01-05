import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _restaurantList = [];
    _state = ResultState.loading;
    _fetchAllRestaurant();
  }

  late List<Restaurant> _restaurantList;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  List<Restaurant> get restaurantList => _restaurantList;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantList = await apiService.getAllRestaurantList();
      print('Restaurant List --> $restaurantList');
      if (restaurantList.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Restoran Kosong';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantList = restaurantList;
      }
    } catch (e) {
      print('Error on _fetchAllRestaurant --> $e');
      if (e is SocketException) {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Tidak Ada Koneksi Internet';
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Terjadi Kesalahan Saat Load Data Restoran';
      }
    }
  }
}
