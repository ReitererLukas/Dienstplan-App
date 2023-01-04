import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/style/border.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class RegisterLinkScreen extends StatefulWidget {
  const RegisterLinkScreen({super.key});

  @override
  State<RegisterLinkScreen> createState() => RegisterLinkScreenState();
}

class RegisterLinkScreenState extends State<RegisterLinkScreen> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    getIt<CalendarManager>().clearServiceList();
    return Scaffold(
      appBar: DienstplanAppBar(
        stateOfScreen: this,
        showSettings: false,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                Text("Dienstplan-App",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: const Text(
                        "Kalendar Link vom\nDienstplan-Portal einfügen",
                        textAlign: TextAlign.center),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Namen eingeben";
                        } else if (value.contains(" ")) {
                          return "Der Name darf keine Leerzeichen beinhalten";
                        }
                        return null;
                      },
                      decoration: textFieldBorderDecoration(hintT: "Name"),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: TextFormField(
                      controller: linkController,
                      validator: (url) {
                        if (url == null || url.isEmpty) {
                          return "Kalender Link eingeben";
                        } else if (!(Uri.parse(url).isAbsolute &&
                            url.endsWith("/Private.ics"))) {
                          return "Link ist nicht valide";
                        }
                        return null;
                      },
                      decoration: textFieldBorderDecoration(hintT: "Kalender Link"),
                    ),
                  ),
                  ElevatedButton(
                      child: const Text("Kalender hinzufügen"),
                      onPressed: () => onRegister(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onRegister(context) async {
    if (_formKey.currentState!.validate()) {
      User user = User(name: nameController.text, link: linkController.text);
      await getIt<UserManager>().addUser(user);
      Navigator.pushNamedAndRemoveUntil(context, "/list", (r) => false);
    }
  }
}
