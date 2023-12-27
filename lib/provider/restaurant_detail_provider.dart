import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/result_state.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail_model.dart';

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  DetailProvider({required this.restaurantId, required this.apiService}) {
    getDetailRestaurant();
  }

  late RestaurantDetail _restaurantResult;
  late ResultState _state;
  String _message = '';

  ResultState get state => _state;
  RestaurantDetail get restaurantDetail => _restaurantResult;
  String get message => _message;

  Future<dynamic> getDetailRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detailRestaurant =
          await apiService.getRestaurantDetail(restaurantId);
      if (!detailRestaurant.error) {
        _state = ResultState.hasData;
        _restaurantResult = detailRestaurant;
      } else {
        _state = ResultState.noData;
        return _message = 'no data';
      }
    } catch (e) {
      _state = ResultState.error;
      return _message = 'Terjadi Kesalahan';
    } finally {
      notifyListeners();
    }
  }
}
