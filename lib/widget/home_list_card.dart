import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/model/restaurant_model.dart';
import 'package:restaurant_app_api/pages/restaurant_detail_page.dart';

class HomeListCard extends StatelessWidget {
  const HomeListCard({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
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
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: white,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
