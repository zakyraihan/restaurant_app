import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/result_state.dart';
import 'package:restaurant_app_api/common/style.dart';
import 'package:restaurant_app_api/data/model/search_restaurant_model.dart';
import 'package:restaurant_app_api/provider/search_provider.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? TextField(
                controller: searchController,
                onChanged: (value) {
                  onSearchTextChanged(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search Restaurant',
                ),
              )
            : const Text('Search Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              setState(() {
                isSearch = !isSearch;
              });

              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                await context.read<SearchProvider>().searchRestaurant(query);
              }
            },
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          switch (searchProvider.state) {
            case ResultState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ResultState.hasData:
              return _buildSearchResult(searchProvider.searchResults);
            case ResultState.noData:
              return Center(
                child: Text(searchProvider.message),
              );
            case ResultState.error:
              return Center(
                child: Text(searchProvider.message),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void onSearchTextChanged(String newText) {
    final query = newText.trim();
    if (query.isNotEmpty) {
      context.read<SearchProvider>().searchRestaurant(query);
    }
  }

  Widget _buildSearchResult(RestaurantSearch searchResult) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: searchResult.restaurants.length,
      itemBuilder: (context, index) {
        var restaurant = searchResult.restaurants[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RestaurantDetailPage()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}'),
                    fit: BoxFit.cover,
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
      },
    );
  }
}
