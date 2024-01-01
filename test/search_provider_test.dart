import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';
import 'package:restaurant_app_api/data/model/search_restaurant_model.dart';

import 'dummy_data.dart';

void main() {
  test('Tes Parsing Daftar Restoran JSON', () async {
    var result = RestaurantResult.fromJson(dummyListResult);

    expect(result.error, dummyListResult['error']);
    expect(result.message, dummyListResult['message']);
    expect(result.count, dummyListResult['count']);
    expect(result.restaurants.length, 20);

    expect(result.restaurants[0].id, 'rqdv5juczeskfw1e867');
  });

  test('Tes Parsing Data Pencarian Restoran JSON', () async {
    var result = RestaurantSearch.fromJson(dummySearchResult);

    expect(result.error, dummySearchResult['error']);
    expect(result.founded, dummySearchResult['founded']);

    expect(result.restaurants.length, 1);
    expect(result.restaurants[0].id, 'rqdv5juczeskfw1e867');
  });

  test('Detail Tes Parsing Data Restoran JSON', () async {
    var result = RestaurantDetail.fromJson(dummyDetailResult);

    expect(result.error, dummyDetailResult['error']);
    expect(result.message, dummyDetailResult['message']);
    expect(result.message, 'success');

    expect(result.restaurant.id, 'rqdv5juczeskfw1e867');
    expect(result.restaurant.name, 'Melting Pot');
    expect(result.restaurant.city, 'Medan');
  });
}
