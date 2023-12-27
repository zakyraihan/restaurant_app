import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/detail_provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, this.restaurantId}) : super(key: key);
  final String? restaurantId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
      ),
      body: Consumer<DetailProvider>(
        builder: (context, detailProvider, _) {
          switch (detailProvider.state) {
            case DetailResultState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case DetailResultState.hasData:
              final restaurantDetail = detailProvider.restaurantDetail;
              // Build your UI using the restaurantDetail data
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${restaurantDetail.restaurant.name}'),
                  Text(
                      'Description: ${restaurantDetail.restaurant.description}'),
                  // Add more details as needed
                ],
              );
            case DetailResultState.noData:
              return Center(
                child: Text(detailProvider.message),
              );
            case DetailResultState.error:
              return Center(
                child: Text(detailProvider.message),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
