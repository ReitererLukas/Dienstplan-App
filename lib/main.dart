import 'dart:async';

import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/dal/repository/service_repo.dart';
import 'package:dienstplan/screens/all_service_screen.dart';
import 'package:dienstplan/screens/menu_screen.dart';
import 'package:dienstplan/screens/service_detail_screen.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/list_screen.dart';
import 'screens/register_link_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await setup();
  } on TimeoutException catch (ex) {
    runApp(const MyApp(error: true,));
  }
  runApp(const MyApp());
}

final getIt = GetIt.instance;
late final SharedPreferences prefs;

Future setup() async {
  getIt.registerSingleton<CalendarManager>(CalendarManager());
  getIt.registerSingleton<ServiceRepo>(ServiceRepo());
  getIt.registerSingleton<CalendarDatabase>(CalendarDatabase());
  prefs = await SharedPreferences.getInstance();

  await getIt<ServiceRepo>().open();

  if (prefs.containsKey("calendarLink")) {
    await getIt<CalendarManager>().loadList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, bool error = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dienstplan',
      theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
          dialogBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
          textTheme: Theme
              .of(context)
              .textTheme
              .apply(bodyColor: Colors.white)
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/registerLink': (context) => RegisterLinkScreen(),
        '/list': (context) => const ListScreen(),
        "/settings": (context) => const MenuScreen(),
        "/list/details": (context) => const ServiceDetailScreen(),
        "/list/all": (context) => const AllServiceScreen(),
      },
      initialRoute: prefs.containsKey("calendarLink")
          ? "/list"
          : "/registerLink",
    );
  }
}
