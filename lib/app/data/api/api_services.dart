import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/data/models/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  // GET - Restaurant List
  static const String _getList = '/list';
  // GET - Restauran Detail
  static const String _getRestaurantDetail = '/detail/';
  // GET - Search Restaurant
  static const String _getSearchRestaurant = '/search?q=';
  // POST - Send Review with Body
  static const String _postReview = '/review';

  Future<List<Restaurant>> getAllRestaurantList(http.Client client) async {
    final response = await client.get(Uri.parse(_baseUrl + _getList));
    final responseBody = jsonDecode(response.body);
    print('Response Status Code --> ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response Body on Get List --> ${response.body}');
      print('Restaurants on Get List --> ${responseBody['restaurants']}');

      return restaurantFromJson(jsonEncode(responseBody['restaurants']));
    } else {
      throw Exception('Failed to Load Restaurant Data');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(
      String restaurantId, http.Client client) async {
    final response = await client
        .get(Uri.parse(_baseUrl + _getRestaurantDetail + restaurantId));
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(responseBody['restaurant']);
    } else {
      throw Exception('Failed to Load Restaurant Details Data');
    }
  }

  Future<List<Restaurant>> getSearchResult(
      String query, http.Client client) async {
    final response =
        await client.get(Uri.parse(_baseUrl + _getSearchRestaurant + query));
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Response Body on Get List --> ${response.body}');
      print('Restaurants on Get List --> ${responseBody['restaurants']}');

      return restaurantFromJson(jsonEncode(responseBody['restaurants']));
    } else {
      throw Exception('Failed to Search Restaurant Data');
    }
  }

  Future<List<CustomerReview>> postReview(http.Client client,
      {required String restaurantId,
      required String name,
      required String review}) async {
    final body = {
      'id': restaurantId,
      'name': name,
      'review': review,
    };
    final response =
        await client.post(Uri.parse(_baseUrl + _postReview), body: body);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 201) {
      print('Response Body on Get List --> $responseBody');

      final List<dynamic> reviewsData = responseBody['customerReviews'];
      final List<CustomerReview> customerReviews = reviewsData
          .map((reviewData) => CustomerReview.fromJson(reviewData))
          .toList();

      return customerReviews;
    } else {
      throw Exception('Failed to Send Review Restaurant Data');
    }
  }
}
