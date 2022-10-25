import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/button.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(context, showSettings: false),
      body: Column(
        children: [
          SettingsSwitchButton(
            text: "Dienstplan archivieren",
            isOn: true,
            action: (val) => debugPrint("$val archivieren"),
          ),
          SettingsButton(text: "Dienstplan entfernen", action: removeDienstplan)
        ],
      ),
    );
  }

  void removeDienstplan() {
    prefs.remove("calendarLink").then((value) {
      if (value) {
        getIt<CalendarManager>().clear();
        Navigator.pushNamedAndRemoveUntil(
            context, "/registerLink", (r) => false);

      }
    });
  }
}
