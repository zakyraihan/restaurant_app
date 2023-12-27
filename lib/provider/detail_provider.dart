import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/detail_model.dart';

enum DetailResultState { loading, noData, hasData, error }

class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String? restaurantId;

  DetailProvider({required this.apiService, required this.restaurantId}) {
    getDetailRestaurant();
  }

  late RestaurantDetail _restaurantDetail;
  late DetailResultState _state;
  String _message = '';

  RestaurantDetail get restaurantDetail => _restaurantDetail;
  String get message => _message;
  DetailResultState get state => _state;

  Future<dynamic> getDetailRestaurant() async {
    try {
      _state = DetailResultState.loading;
      notifyListeners();

      final response = await apiService.getRestaurantDetail(restaurantId ?? '');

      if (response.error) {
        _state = DetailResultState.noData;
        notifyListeners();
        return _message = 'no data';
      } else {
        _state = DetailResultState.hasData;
        notifyListeners();
        return _restaurantDetail = response;
      }
    } catch (e) {
      _state = DetailResultState.error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
