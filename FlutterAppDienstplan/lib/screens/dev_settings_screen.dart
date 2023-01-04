import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/dev_settings.dart';
import 'package:dienstplan/components/settings/section_title.dart';
import 'package:dienstplan/components/settings/settings_button.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/helpers/utils.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class DevSettingsScreen extends StatefulWidget {
  const DevSettingsScreen({super.key});

  @override
  State<DevSettingsScreen> createState() => DevSettingsScreenState();
}

class DevSettingsScreenState extends State<DevSettingsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: DienstplanAppBar(showSettings: false, stateOfScreen: this),
      body: const DevSettings(),
    );
  }
}
