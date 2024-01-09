import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/app/data/api/api_services.dart';
import 'package:restaurant_app/app/data/models/restaurant.dart';
import 'package:restaurant_app/app/data/models/restaurant_detail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Api Service Test', () {
    final client = MockClient();
    ApiService apiService = ApiService();

    const mockRestaurantList = '''{
      "error": false,
      "message": "success",
      "count": 2,
      "restaurants": [
            {"id": "1", "name": "Restaurant 1", "description": "Description 1", "pictureId": "1", "city": "City 1", "rating": 4.5},
            {"id": "2", "name": "Restaurant 2", "description": "Description 2", "pictureId": "2", "city": "City 2", "rating": 4.5}
          ]
    }''';

    const mockRestaurantDetail = '''{
      "error": false,
      "message": "success",
      "restaurant": {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
          "city": "Medan",
          "address": "Jln. Pandeglang no 19",
          "pictureId": "14",
          "categories": [
              {
                  "name": "Italia"
              },
              {
                  "name": "Modern"
              }
          ],
          "menus": {
              "foods": [
                  {
                      "name": "Paket rosemary"
                  },
                  {
                      "name": "Toastie salmon"
                  }
              ],
              "drinks": [
                  {
                      "name": "Es krim"
                  },
                  {
                      "name": "Sirup"
                  }
              ]
          },
          "rating": 4.2,
          "customerReviews": [
              {
                  "name": "Ahmad",
                  "review": "Tidak rekomendasi untuk pelajar!",
                  "date": "13 November 2019"
              }
          ]
      }
    }''';

    const mockSearchResult = '''
    {
      "error": false,
      "founded": 1,
      "restaurants": [
          {
              "id": "fnfn8mytkpmkfw1e867",
              "name": "Makan mudah",
              "description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
              "pictureId": "22",
              "city": "Medan",
              "rating": 3.7
          }
      ]
    }''';

    test('Test parsing getAllRestaurantList function on ApiService', () async {
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(mockRestaurantList, 200));
      var restaurantList = await apiService.getAllRestaurantList(client);
      expect(restaurantList, isA<List<Restaurant>>());
    });

    test('Test parsing getRestaurantDetail function on ApiService', () async {
      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response(mockRestaurantDetail, 200));
      var restaurantDetail =
          await apiService.getRestaurantDetail('rqdv5juczeskfw1e867', client);
      expect(restaurantDetail, isA<RestaurantDetail>());
    });

    test('Test parsing getSearchResult function on ApiService', () async {
      when(client.get(
              Uri.parse('https://restaurant-api.dicoding.dev/search?q=Kafe')))
          .thenAnswer((_) async => http.Response(mockSearchResult, 200));
      var searchResult = await apiService.getSearchResult('Kafe', client);
      expect(searchResult, isA<List<Restaurant>>());
    });
  });
}
