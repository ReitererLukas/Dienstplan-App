import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
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

List<Service> dbToObjects(List res, {bool sort=true}) {
  List<Service> services = [];
  for (Map<String, dynamic> s in res) {
    services.add(Service.fromDB(s));
  }

  if(sort) {
    services.sort((a, b) {
      if(a.startTime.compareTo(b.startTime) == 0) {
        return b.timestamp.compareTo(a.timestamp);
      }
      return a.startTime.compareTo(b.startTime);
    });
  }
  return services;
}
