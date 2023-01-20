import 'package:dienstplan/components/dialogs/confirmation_dialog.dart';
import 'package:dienstplan/helpers/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final State stateOfScreen;

  const Menu(State this.stateOfScreen, {super.key});

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          getElement(
              title: "Dienstplan ändern",
              onTap: () => Navigator.pushNamed(context, "/dienstplan/list"),
              icon: Icons.calendar_month),
          getElement(
              title: "Einstellungen",
              onTap: () => onTapHandler(() =>
                  Navigator.pushNamed(context, "/settings")
                      .then((_) => widget.stateOfScreen.setState(() {}))),
              icon: Icons.settings),
          getElement(
              title: "Dienstplan entfernen",
              onTap: removeDienstplan,
              icon: Icons.logout),
        ],
      ),
    );
  }

  void onTapHandler(Function function) {
    Navigator.pop(context);
    function();
  }

  void removeDienstplan() async {
    List res = await showDialog(
        context: context,
        builder: ((context) => ConfirmationDialog(
            text: "Dienstplan entfernen?")),
        barrierDismissible: false);
    if(res.isNotEmpty && res[0]) {
      removeDienstplanLocally(context);
    }
  }

  Widget getElement(
      {required String title,
      required Function onTap,
      required IconData icon}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        // margin: const EdgeInsets.only(left: 20),
        padding: const EdgeInsets.only(left: 20, bottom: 30),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Icon(icon, color: Colors.white),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
