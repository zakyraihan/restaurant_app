import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/result_state.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/detail_model.dart';
import 'package:restaurant_app_api/provider/detail_provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/detail-page';

  final Restaurants? restaurants;

  const RestaurantDetailPage({Key? key, this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantDetailProvider(
          apiService: ApiService(), restaurants: restaurants),
      child: Consumer<RestaurantDetailProvider>(
        builder: (context, state, child) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            var restaurant = state.result;
            return Scaffold(
              appBar: AppBar(title: Text(restaurant.restaurant.name)),
              body: ListTile(
                title: Text(restaurant.restaurant.name),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.network_wifi_sharp),
                    Text('Sorry, no internet connection...'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }
}
