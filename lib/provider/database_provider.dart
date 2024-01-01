import 'package:flutter/foundation.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';
import 'package:restaurant_app_api/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  late ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorite = [];
  List<Restaurant> get favorite => _favorite;

  void _getFavorite() async {
    _favorite = await databaseHelper.getBookmarks();
    if (_favorite.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertBookmark(restaurant);
      _getFavorite();
    } catch (e) {
      _state = ResultState.error;
      _message = '$e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getBookmarkById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  Future<void> removeFavorite(String id) async {
    try {
      await databaseHelper.removeBookmark(id);
      _getFavorite();
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = '$e';
      notifyListeners();
    }
  }
}
