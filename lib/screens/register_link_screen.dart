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
    return Scaffold(
      appBar: DienstplanAppBar(context),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                Text("Dienstplan-App", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                Container(
                  child: Text("Kalendar Link vom\nDienstplan-Portal einfügen",
                      textAlign: TextAlign.center),
                  margin: EdgeInsets.only(bottom: 25),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: TextField(
                    controller: linkFieldController,
                    // autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      hintText: "Kalender Link",
                      hintStyle: TextStyle(color: Color.fromARGB(120, 255,255,255),)
                    ),
                  ),
                ),
                ElevatedButton(
                    child: const Text("Kalender hinzufügen"),
                    onPressed: () => onRegister(context)),
              ],
            ),
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
