import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';
import 'package:restaurant_app_api/pages/restaurant_detail_page.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';

class HomeListCard extends StatelessWidget {
  const HomeListCard({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorite(restaurant.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                    arguments: restaurant.id);
              },
              child: Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.black.withOpacity(0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: style(
                              fs: 18,
                              fw: FontWeight.w500,
                              color: white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        restaurant.city,
                                        style: style(
                                          fs: 15,
                                          fw: FontWeight.w500,
                                          color: white,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 20,
                                        color: yellow,
                                      ),
                                      Text(
                                        restaurant.rating.toString(),
                                        style: style(
                                          fs: 15,
                                          fw: FontWeight.w500,
                                          color: white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              isFavorite
                                  ? IconButton(
                                      onPressed: () => provider
                                          .removeFavorite(restaurant.id),
                                      icon: const Icon(Icons.favorite),
                                      color: Colors.red,
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.favorite_border),
                                      color: Colors.red,
                                      onPressed: () =>
                                          provider.addFavorite(restaurant),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
