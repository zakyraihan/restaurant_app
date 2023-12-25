import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/result_state.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/search_restaurant_model.dart';


class SearchProvider extends ChangeNotifier {
  final ApiService apiService;
  String query = '';

  SearchProvider({required this.apiService}) {
    searchRestaurant(query);
  }

  late ResultState _state;
  String _message = '';

  ResultState get state => _state;
  String get message => _message;

  late RestaurantSearch _restaurantSearchResult;
  RestaurantSearch get searchResults => _restaurantSearchResult;

  Future<dynamic> searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchResult = await apiService.searchRestaurant(query);
      log(searchResult.toString());
      if (searchResult.restaurants.isEmpty) {
        _state = ResultState.noData;
        return _message = 'Data Not Found';
      } else {
        _state = ResultState.hasData;
        return _restaurantSearchResult = searchResult;
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }
}
