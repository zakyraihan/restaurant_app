import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/navigation.dart';
import 'package:restaurant_app_api/data/api/restaurant_service.dart';
import 'package:restaurant_app_api/pages/restaurant_detail_page.dart';
import 'package:restaurant_app_api/pages/restaurant_list_page.dart';
import 'package:restaurant_app_api/pages/restaurant_search_page.dart';
import 'package:restaurant_app_api/pages/restaurant_settings_page.dart';
import 'package:restaurant_app_api/provider/restaurant_provider.dart';
import 'package:restaurant_app_api/provider/restaurant_scheduling_provider.dart';
import 'package:restaurant_app_api/provider/search_provider.dart';
import 'package:restaurant_app_api/utils/background_service.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
          child: const SettingsPage(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: ThemeData.dark(),
        home: const RestaurantListPage(),
        initialRoute: RestaurantListPage.routeName,
        routes: {
          RestaurantListPage.routeName: (context) => const RestaurantListPage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
          SearchPage.routeName: (context) => const SearchPage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              restaurant: ModalRoute.of(context)?.settings.arguments as String),
        },
      ),
    );
  }

  @override
  void initState() {
    _notificationHelper.configureSelectNotificationSubject(
        RestaurantDetailPage.routeName, context);
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
