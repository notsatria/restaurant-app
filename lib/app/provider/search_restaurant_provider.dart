import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class SearchRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchRestaurantProvider({required this.apiService});

  List<Restaurant> _searchResult = [];
  late ResultState _state = ResultState.noData;
  String _message = '';

  final searchTextController = TextEditingController();

  String get message => _message;

  List<Restaurant> get searchResult => _searchResult;

  ResultState get state => _state;

  Future<dynamic> searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchResult = await apiService.getSearchResult(query);
      print('Restaurant List --> $searchResult');
      if (searchResult.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Pencarian Belum Ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = searchResult;
      }
    } catch (e) {
      print('Error on searchRestaurant --> $e');
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
}
