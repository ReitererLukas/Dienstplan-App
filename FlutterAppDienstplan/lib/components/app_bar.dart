import 'package:dienstplan/components/menu/menu.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class DienstplanAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 50;
  final bool showSettings, arrowBack;
  final State stateOfScreen;

  DienstplanAppBar(
      {this.showSettings = true,
      this.arrowBack = true,
      required this.stateOfScreen});

  @override
  DienstplanAppBarState createState() => DienstplanAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class DienstplanAppBarState extends State<DienstplanAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text("Dienstplan"),
        actions: [
          widget.showSettings
              ? TextButton(
                  onPressed: () {
                    _showMenu();
                    // Navigator.pushNamed(context, "/settings").then((_) => setState(() {}));
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Text(
                      getIt<UserManager>().activeUser!.name.substring(0, 1),
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                )
              : Container()
        ],
        automaticallyImplyLeading: widget.arrowBack);
  }

  void _showMenu() {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
            return Wrap(
              children: [Menu(widget.stateOfScreen)],
            );
        }));
  }
}
