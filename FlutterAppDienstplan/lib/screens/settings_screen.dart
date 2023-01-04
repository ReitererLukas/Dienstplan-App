import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/settings/button.dart';
import 'package:dienstplan/components/settings/section_title.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/helpers/utils.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  bool useArchiver = getIt<UserManager>().activeUser!.archive;
  bool notificationPermission = getIt<UserManager>().activeUser!.notificationId != "";
  bool devPermissions = prefs.getBool("isDev") ?? false;
  bool useNotificationServer = prefs.getBool("useNotificationServer") ?? true;

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
          Container(margin: EdgeInsets.all(10),),
          const SectionTitle(text: "Developer Options"),
          SettingsSwitchButton(
            text: "Dev Mode",
            isOn: devPermissions,
            action: (input) => devPermissions?disableDevMode():enableDevMode(input),
            useInputDialogConfirmation: true,
            confirmationDialogText: "Dev Password: ",
          ),
          ...devOptions(),
        ],
      ),
    );
  }

  List<Widget> devOptions() {
    if(prefs.getBool("isDev") ?? false) {
      return [
        SettingsSwitchButton(
          text: "Use Notification Server",
          isOn: useNotificationServer,
          action: (val) => switchServerFeatures(val),
        ),
      ];
    }
    return [];
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

  bool enableDevMode(String? input) {
    bool isDev = input == dotenv.get("devMenuPwd");
    prefs.setBool("isDev", isDev);
    devPermissions = true;
    setState(() {});
    return isDev;
  }

  void disableDevMode() {
    prefs.setBool("isDev", false);
    switchServerFeatures(true);
    devPermissions = false;
    setState(() {});
  }

  Future<void> switchServerFeatures(bool val) async {
    await prefs.setBool("useNotificationServer", true);
    if(val) {
      // activate -> register all to server
      await getIt<UserManager>().activateServerFeaturesForAllUsers();
    } else {
      // deactivate -> remove all from server
      await getIt<UserManager>().deactivateServerFeaturesForAllUsers();
    }
    await prefs.setBool("useNotificationServer", val);
  }
}
