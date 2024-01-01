import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getDailyNewsPreferences();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyNewsRestaurant = false;
  bool get isDailyRestaurantActive => _isDailyNewsRestaurant;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarktheme(value);
    _getTheme();
  }

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  void _getDailyNewsPreferences() async {
    _isDailyNewsRestaurant = await preferencesHelper.isDailyRestaurant;
    notifyListeners();
  }

  void enableDailyNews(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getDailyNewsPreferences();
  }
}
