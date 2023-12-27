import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:restaurant_app_api/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';
import 'package:restaurant_app_api/data/model/search_restaurant_model.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantResult> fetchAllData() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed To Fetch Restaurant Data');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String restaurantId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/detail/$restaurantId'));

    if (response.statusCode == 200) {
      return restaurantDetailFromJson(response.body);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed To Search Restaurant Data');
    }
  }

  Future<void> postReview(String restaurantId, CustomerReview review) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": restaurantId,
        "name": review.name,
        'review': review.review,
        'date': review.date,
      }),
    );

    if (response.statusCode == 200) {
      log('Review posted successfully');
    } else {
      log('Failed to post review. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  }
}
