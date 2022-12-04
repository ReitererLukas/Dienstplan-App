import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/button.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  bool useArchiver = getIt<UserManager>().archive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(showSettings: false, stateOfScreen: this),
      body: Column(
        children: [
          SettingsSwitchButton(
            text: "Dienstplan archivieren",
            isOn: useArchiver,
            action: switchArchiveMode,
            useConfirmationDialog: true,
            confirmationDialogText:
                "Willst du Archivieren wirklich deaktivieren? Alle deine Daten gehen dadurch verloren!!!",
          ),
          SettingsButton(
              text:
                  "Dienstplan ${getIt<UserManager>().activeUser!.name} entfernen",
              action: removeDienstplan)
        ],
      ),
    );
  }

  void removeDienstplan() {
    prefs.remove("userId").then((value) async {
      if (value) {
        getIt<UserManager>().removeUser().then((value) {
          if (getIt<UserManager>().users.isEmpty) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/registerLink", (r) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, "/dienstplan/list", (r) => false);
          }
        });
      }
    });
  }

  void switchArchiveMode() {
    getIt<UserManager>().switchArchiveMode();
  }
}
