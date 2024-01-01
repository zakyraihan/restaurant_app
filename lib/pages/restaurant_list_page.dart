import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/pages/restaurant_favorite_page.dart';
import 'package:restaurant_app_api/pages/restaurant_search_page.dart';
import 'package:restaurant_app_api/pages/restaurant_settings_page.dart';
import 'package:restaurant_app_api/provider/restaurant_provider.dart';
import 'package:restaurant_app_api/utils/result_state.dart';
import 'package:restaurant_app_api/widget/home_list_card.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = 'list_page';
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  bool isSearchActive = false;
  bool isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => navigator.pushNamed(SettingsPage.routeName),
                  icon: isIos
                      ? const Icon(CupertinoIcons.settings)
                      : const Icon(Icons.settings),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/Group 57.png',
                  fit: BoxFit.cover,
                ),
                centerTitle: false,
                title: const Text(
                  'Restaurant App',
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
          ];
        },
        body: _buildList(context),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: const Icon(Icons.search),
            label: 'search',
          ),
          SpeedDialChild(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RestaurantFavoritePage()),
            ),
            child: const Icon(Icons.favorite),
            label: 'favorite',
          )
        ],
      ),
    );
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
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = state.result.restaurants[index];
                  return HomeListCard(restaurant: restaurant);
                },
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
