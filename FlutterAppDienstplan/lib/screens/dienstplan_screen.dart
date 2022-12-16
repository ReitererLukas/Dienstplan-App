import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/lists/dienstplan_list_element.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class DienstplanScreen extends StatefulWidget {
  const DienstplanScreen({super.key});

  @override
  State<DienstplanScreen> createState() => DienstplanScreenState();
}

class DienstplanScreenState extends State<DienstplanScreen> {
  @override
  Widget build(BuildContext context) {
    getIt<CalendarManager>().clearServiceList();
    return Scaffold(
      appBar: DienstplanAppBar(stateOfScreen: this, showSettings: false),
      body: ListView(
        children: createListViewElements(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/registerLink"),
        child: const Icon(Icons.add_rounded, size: 50),
      ),
    );
  }

  List<Widget> createListViewElements(BuildContext context) {
    List<Widget> elements = [];

    List<User> users = getIt<UserManager>().users;
    if (getIt<UserManager>().activeUser != null) {
      elements.add(DienstplanListElement(
        user: getIt<UserManager>().activeUser!,
        isActive: true,
        onTap: switchUser,
      ));
      users = users
          .where(
              (user) => user.userId != getIt<UserManager>().userId)
          .toList();
    }

    for (User user in users) {
      elements.add(DienstplanListElement(
        user: user,
        onTap: switchUser,
      ));
    }

    return elements;
  }

  void switchUser(user) {
    getIt<UserManager>().switchUser(user);
    Navigator.pushNamedAndRemoveUntil(context, "/list", (route) => false);
  }
}
