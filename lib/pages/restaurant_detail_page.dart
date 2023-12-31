import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_api/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app_api/utils/result_state.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const String routeName = '/restaurant_detail';

  final String restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DetailProvider(
        apiService: ApiService(),
        restaurantId: widget.restaurant.toString(),
      ),
      child: Consumer<DetailProvider>(
        builder: (context, detailProvider, _) {
          if (detailProvider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (detailProvider.state == ResultState.hasData) {
            var restaurantDetail = detailProvider.restaurantDetail;
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 270,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          'https://restaurant-api.dicoding.dev/images/medium/${restaurantDetail.restaurant.pictureId}',
                          fit: BoxFit.cover,
                        ),
                        titlePadding:
                            const EdgeInsets.only(left: 16, bottom: 16),
                      ),
                    )
                  ];
                },
                body: _detailBody(restaurantDetail),
              ),
            );
          } else if (detailProvider.state == ResultState.noData) {
            return Center(
              child: Text(detailProvider.message),
            );
          } else if (detailProvider.state == ResultState.error) {
            return const Material(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error),
                    Text('Terjadi Kesalahan'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  SingleChildScrollView _detailBody(RestaurantDetail restaurantDetail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantDetail.restaurant.name,
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const Gap(3),
                        Text(
                          restaurantDetail.restaurant.city,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 20),
                        const Gap(3),
                        Text(
                          restaurantDetail.restaurant.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Gap(15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    restaurantDetail.restaurant.description,
                    maxLines: isExpanded ? 5 : 1000,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const Gap(15),
                Text(
                  'Foods',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildFoodCategories(restaurantDetail.restaurant.menus.foods),
                const Gap(18),
                Text(
                  'Drinks',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildDrinksCategories(
                    restaurantDetail.restaurant.menus.drinks),
                const Gap(18),
                Text(
                  'Customer Review',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(5),
                _costumerReview(restaurantDetail.restaurant.customerReviews)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCategories(List<Category> foodCategories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: foodCategories
              .map((foodCategory) => Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      foodCategory.name,
                      style: style(fs: 17),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDrinksCategories(List<Category> drinksCategories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: drinksCategories
              .map((foodCategory) => Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      foodCategory.name,
                      style: style(fs: 17),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _costumerReview(List<CustomerReview> customerReview) {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: customerReview
                .map((foodCategory) => Card(
                      child: Container(
                        child: ListTile(
                          title: Text(foodCategory.name),
                          subtitle: Text(foodCategory.review),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
