import 'package:dienstplan/main.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/cupertino.dart';

void removeDienstplanLocally(BuildContext context) {
  prefs.remove("userId").then((value) async {
    if (value) {
      getIt<UserManager>().removeUser().then((value) {
        if (getIt<UserManager>().users.isEmpty) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/registerLink", (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/dienstplan/list", (r) => false);
        }
      });
    }
  });
}
