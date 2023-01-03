import 'dart:convert' show utf8;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CalendarLoader {
  static final CalendarLoader _manager = CalendarLoader._internal();

  factory CalendarLoader() {
    return _manager;
  }

  CalendarLoader._internal();

  Future<List<Service>> loadCalendar() async {
    getIt<NotificationServer>().refreshTimerOfDienstplanOnServer(getIt<UserManager>().activeUser!.notificationId);

    if ((await Connectivity().checkConnectivity()) != ConnectivityResult.none &&
        getIt<UserManager>().activeUser != null) {
      String calendar =
          await get(Uri.parse(getIt<UserManager>().activeUser!.link))
              .timeout(const Duration(seconds: 10))
              .then((resp) => utf8.decode(resp.bodyBytes));
      return translateServices(findServices(calendar));
    }
    return [];
  }

  List<Map<String, String>> findServices(String calendar) {
    List<String> services = calendar.split("BEGIN:VEVENT");
    services.removeAt(0);

    List<Map<String, String>> rawServices = [];
    for (var service in services) {
      List<String> lines = service.split("\n");
      lines = lines.map((element) => element.replaceAllMapped(RegExp(r"&[auo]uml\\;", caseSensitive: false), (match) {
        if(match.group(0) != null) {
          switch(match.group(0)!.substring(0,2).toLowerCase()) {
            case "&a":
              return "ä";
            case "&u":
              return "ü";
            case "&o":
              return "ö";
          }
        }
        return match.group(0)!;
      })).toList();
      lines = lines.map((e) => e.replaceAll(RegExp(r"&nbsp\\;"), "")).toList();
      lines = lines.map((e) => e.replaceAll(RegExp(r"\\,"), ",")).toList();
      lines = lines.map((e) => e.replaceAll(RegExp(r"\\n"), " ")).toList();
      lines = lines.map((e) => e.replaceAll(RegExp(r"\s{2,}"), " ")).toList();

      int index = 0;
      while (index < lines.length) {
        if(lines[index].startsWith(" ") && index > 0) {
          lines[index-1] = lines[index-1].substring(0, lines[index-1].length-1) + lines[index].substring(1);
          lines.removeAt(index);
          continue;
        }
        index++;
      }

      lines.removeLast();
      lines.removeAt(0);
      rawServices.add(Map.fromEntries(lines.where((line) => line != "").map(
          (line) {
            List<String> tokens = line.split(":");
            String key = tokens.removeAt(0).toLowerCase();
            return MapEntry(
              key, tokens.reduce((e1,e2) => "$e1:$e2").trim());
          })));
    }

    return rawServices;
  }

  List<Service> translateServices(List<Map<String, String>> rawServices) {
    return rawServices.map((e) => Service.fromCalendar(e)).toList();
  }
}
