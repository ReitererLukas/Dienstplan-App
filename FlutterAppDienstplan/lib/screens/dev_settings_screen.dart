import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/dev_settings.dart';
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
