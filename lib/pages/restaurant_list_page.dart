import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/result_state.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/pages/restaurant_detail_page.dart';
import 'package:restaurant_app_api/pages/restaurant_search_page.dart';
import 'package:restaurant_app_api/provider/restaurant_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();

  final Uri _url = Uri.parse('https://www.instagram.com/c.adnya/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                actions: [
                  IconButton(
                    onPressed: _launchUrl,
                    icon: const Icon(Iconsax.instagram),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/Group 57.png',
                    fit: BoxFit.cover,
                  ),
                  centerTitle: false,
                  title: Text(
                    'Restaurant App',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                ),
              ),
            ];
          },
          body: _buildList(context),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          ),
          child: const Icon(Icons.search),
        ));
  }

  Widget _buildList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          context.read<RestaurantProvider>().fetchAllData();
        });
      },
      child: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (state.state == ResultState.hasData) {
              // tampilan ListTile di layar
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.result.restaurants.length,
                        itemBuilder: (context, index) {
                          var restaurant = state.result.restaurants[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailPage(
                                    restaurantId: restaurant.id,
                                  ),
                                ),
                              );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Text(state.message),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    Text(state.message),
                  ],
                ),
              );
            } else {
              return const Scaffold();
            }
          }
        },
      ),
    );
  }
}
