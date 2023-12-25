import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isExpanded = true;
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Detail', style: style(color: white)),
      ),
      body: FutureBuilder(
        future: _loadRestaurantDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final restaurantDetail = snapshot.data as Map<String, dynamic>;
            return _buildRestaurantDetail(restaurantDetail);
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadRestaurantDetail() async {
    final response = await apiService.getRestaurantDetail(widget.restaurantId);
    final restaurantDetail = response['restaurant'];
    return restaurantDetail;
  }

  Widget _buildRestaurantDetail(Map<String, dynamic> restaurantDetail) {
    List<Map<String, dynamic>> categories =
        (restaurantDetail['categories'] as List).cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> foods =
        (restaurantDetail['menus']['foods'] as List)
            .cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> drinks =
        (restaurantDetail['menus']['drinks'] as List)
            .cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _loadRestaurantDetail();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://restaurant-api.dicoding.dev/images/medium/${restaurantDetail["pictureId"]}',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantDetail['name'].toString(),
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
                            restaurantDetail['city'],
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
                            restaurantDetail['rating'].toString(),
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
                      restaurantDetail['description'],
                      maxLines: isExpanded ? 5 : 1000,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      for (var category in categories)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.deepPurple.shade200),
                                borderRadius: BorderRadius.circular(100)),
                            child: Text(category['name']),
                          ),
                        ),
                    ],
                  ),
                  const Gap(15),
                  Text(
                    'Foods',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildMenuList(foods),
                  const Gap(15),
                  Text(
                    'Drinks',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildMenuList(drinks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<Map<String, dynamic>> menuList) {
    return SizedBox(
      height: 50, // Sesuaikan dengan tinggi yang diinginkan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          var menuItem = menuList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(menuItem['name'].toString()),
            ),
          );
        },
      ),
    );
  }
}
