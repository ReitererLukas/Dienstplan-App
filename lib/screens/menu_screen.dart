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
  bool useArchiver = prefs.getBool("useArchiver") ?? true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(context, showSettings: false, setState: setState,),
      body: Column(
        children: [
          SettingsSwitchButton(
            text: "Dienstplan archivieren",
            isOn: useArchiver,
            action: (val) => switchArchiveMode(val),
            useConfirmationDialog: true,
            confirmationDialogText: "Willst du Archivieren wirklich deaktivieren? Alle deine Daten gehen dadurch verloren!!!",
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

  void switchArchiveMode(bool useArchiver) {
    if(!useArchiver) {
      prefs.setBool("useArchiver", false);
      getIt<CalendarManager>().clearDatabase();
    } else {
      prefs.setBool("useArchiver", true);
    }
  }
}
