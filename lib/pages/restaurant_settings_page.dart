import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/restaurant_scheduling_provider.dart';
import 'package:restaurant_app_api/widget/custom_dialog.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/setting_page';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Settings Page'),
        ),
        body: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling Restaurant'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledRestaurant(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
