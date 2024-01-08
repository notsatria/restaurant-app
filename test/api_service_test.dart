import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/data/models/restaurant_detail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Api Service Test', () {
    ApiService apiService = ApiService();

    test('Test parsing getAllRestaurantList function on ApiService', () async {
      var response = await apiService.getAllRestaurantList();
      expect(response, isA<List<Restaurant>>());
    });

    test('Test parsing getRestaurantDetail function on ApiService', () async {
      var response =
          await apiService.getRestaurantDetail('ateyf7m737ekfw1e867');
      expect(response, isA<RestaurantDetail>());
    });

    test('Test parsing getSearchResult function on ApiService', () async {
      var response = await apiService.getSearchResult('Kafe');
      expect(response, isA<List<Restaurant>>());
    });

    test('Test parsing postReview function on ApiService', () async {
      var response = await apiService.postReview(
          restaurantId: 'ateyf7m737ekfw1e867',
          name: 'Test',
          review: 'Test Review');
      expect(response, isA<List<CustomerReview>>());
    });
  });
}
