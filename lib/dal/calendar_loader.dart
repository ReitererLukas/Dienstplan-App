import 'dart:convert' show utf8;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dienstplan/models/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarLoader {
  static final CalendarLoader _manager = CalendarLoader._internal();

  factory CalendarLoader() {
    return _manager;
  }

  CalendarLoader._internal();

  Future<List<Service>> loadCalendar() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if ((await Connectivity().checkConnectivity()) !=
          ConnectivityResult.none) {
        String calendar = await get(Uri.parse(prefs.getString("calendarLink")!))
            .timeout(const Duration(seconds: 2))
            .then((resp) => utf8.decode(resp.bodyBytes));
        return translateServices(findServices(calendar));
      }
    } catch (e) {
    }
    return [];

  }

  List<Map<String, String>> findServices(String calendar) {
    List<String> services = calendar.split("BEGIN:VEVENT");
    services.removeAt(0);

    List<Map<String, String>> rawServices = [];
    for (var service in services) {
      List<String> lines = service.split("\n");
      lines.removeLast();
      lines.removeAt(0);
      rawServices.add(Map.fromEntries(lines.where((line) => line != "").map(
              (line) =>
              MapEntry(
                  line.split(":")[0].toLowerCase(),
                  line.split(":")[1].trim()))));
    }
    return rawServices;
  }

  List<Service> translateServices(List<Map<String, String>> rawServices) {
    return rawServices.map((e) => Service.fromCalendar(e)).toList();
  }
}
