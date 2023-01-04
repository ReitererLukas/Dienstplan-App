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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
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
          ),
          SettingsButton(
              text:
                  "Dienstplan ${getIt<UserManager>().activeUser!.name} entfernen",
              action: removeDienstplan),
          Container(margin: const EdgeInsets.all(10),),
          const DevSettings(),
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
      getIt<NotificationServer>().removeDienstplan(getIt<UserManager>().activeUser!);
      getIt<UserManager>().setNotificationId('');
    }
  }
}
