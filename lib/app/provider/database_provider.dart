import 'package:flutter/material.dart';
import 'package:restaurant_app/app/data/database/database_helper.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/utils/result_state.dart';
import 'package:restaurant_app/app/widgets/custom_snackbar.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  final List<Restaurant> _favoriteRestaurants = [];
  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;

  void getFavorites() async {
    _state = ResultState.loading;
    notifyListeners();

    final favorites = await databaseHelper.getFavorites();
    if (favorites.isNotEmpty) {
      _favoriteRestaurants.addAll(favorites);
      _state = ResultState.hasData;
      notifyListeners();
    } else {
      _state = ResultState.noData;
      _message = 'Anda belum memiliki restoran favorit';
      notifyListeners();
    }
  }

  void addFavorite(Restaurant restaurant, BuildContext context) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _favoriteRestaurants.add(restaurant);
      _state = ResultState.hasData;
      // ignore: use_build_context_synchronously
      showSuccessSnackBar(context,
          'Restoran berhasil ditambahkan ke daftar favorit. Anda dapat melihatnya di halaman favorit.');
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal menambahkan restoran ke favorit';
      notifyListeners();
    }
  }

  void removeFavorite(String id, BuildContext context) async {
    try {
      await databaseHelper.removeFavorite(id);
      _favoriteRestaurants.removeWhere((restaurant) => restaurant.id == id);
      _state = ResultState.hasData;
      // ignore: use_build_context_synchronously
      showWarningSnackBar(
          context, 'Restoran berhasil dihapus dari daftar favorit.');

      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Gagal menghapus restoran dari favorit';
      notifyListeners();
    }
    if (_favoriteRestaurants.isEmpty) {
      _state = ResultState.noData;
      _message = 'Anda belum memiliki restoran favorit';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavoriteById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void refresh() {
    _favoriteRestaurants.clear();
    getFavorites();
  }
}
