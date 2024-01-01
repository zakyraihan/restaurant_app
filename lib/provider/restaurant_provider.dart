import 'package:flutter/material.dart';
import 'package:restaurant_app_api/utils/result_state.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  String query = '';

  RestaurantProvider({required this.apiService}) {
    fetchAllData();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> fetchAllData() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.fetchAllData();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'empty data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Terjadi Kesalahan';
    }
  }
}
