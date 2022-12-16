import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/button.dart';
import 'package:dienstplan/components/settings/section_title.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/helpers/utils.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  bool useArchiver = getIt<UserManager>().activeUser!.archive;
  bool notificationPermission = getIt<UserManager>().activeUser!.notificationId != "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(showSettings: false, stateOfScreen: this),
      body: Column(
        children: [
          SettingsSwitchButton(
            text: "Dienstplan archivieren",
            isOn: useArchiver,
            action: (val) => switchArchiveMode(),
            useConfirmationDialog: true,
            confirmationDialogText:
                "Willst du Archivieren wirklich deaktivieren? Alle deine Daten gehen dadurch verloren!!!",
          ),
          const SectionTitle(text: "Benachrichtigungen"),
          SettingsSwitchButton(
            text: "Benachrichtigungen",
            isOn: notificationPermission,
            action: (val) => changeNotificationMode(val),
            useConfirmationDialog: false,
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
    removeDienstplanLocally(context);
  }

  void switchArchiveMode() {
    getIt<UserManager>().switchArchiveMode();
  }

  void changeNotificationMode(bool value) async {
    if(value) {
      getIt<UserManager>().setNotificationId(await getIt<NotificationServer>().registerDienstplan(getIt<UserManager>().activeUser!));
    } else {
      getIt<NotificationServer>().removeDienstplan();
      getIt<UserManager>().setNotificationId('');
    }
  }
}
