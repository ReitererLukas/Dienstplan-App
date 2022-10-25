import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/dialogs/error_dialog.dart';
import 'package:dienstplan/main.dart';
import 'package:flutter/material.dart';

import '../stores/calendar_manager.dart';

class RegisterLinkScreen extends StatelessWidget {
  RegisterLinkScreen({super.key});

  final TextEditingController linkFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    linkFieldController.text = "http://192.168.178.121/Private.ics";
    // linkFieldController.text = "https://dienstplan.st.roteskreuz.at/Calendar/1213626/v3VkibGs/Private.ics";

    return Scaffold(
      appBar: DienstplanAppBar(context),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: linkFieldController),
            ElevatedButton(
                child: const Text("Register Calendar"),
                onPressed: () => onRegister(context)),
          ],
        ),
      ),
    );
  }

  void onRegister(context) async {
    if (checkIfUrlIsValid(linkFieldController.text)) {
      prefs.setString("calendarLink", linkFieldController.text);
      await getIt<CalendarManager>().loadList();
      Navigator.pushReplacementNamed(context, "/list");
    } else {
      linkFieldController.text = "";
      showDialog(
          context: context,
          useSafeArea: false,
          builder: (context) => const ErrorDialog(
              text:
                  "Link ist nicht valide!\nDen richtigen Link findest du am Dienstportal"));
    }
  }

  bool checkIfUrlIsValid(String url) {
    return Uri.parse(url).isAbsolute && url.endsWith("/Private.ics");
  }
}
