import 'package:dienstplan/components/settings/section_title.dart';
import 'package:dienstplan/components/settings/switch_button.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DevSettings extends StatefulWidget {
  const DevSettings({Key? key}) : super(key: key);

  @override
  State<DevSettings> createState() => _DevSettingsState();
}

class _DevSettingsState extends State<DevSettings> {
  bool devPermissions = prefs.getBool("isDev") ?? false;
  bool useNotificationServer = prefs.getBool("useNotificationServer") ?? true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
