import 'dart:async';

import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/screens/all_service_screen.dart';
import 'package:dienstplan/screens/dienstplan_screen.dart';
import 'package:dienstplan/screens/loading_screen.dart';
import 'package:dienstplan/screens/service_detail_screen.dart';
import 'package:dienstplan/screens/settings_screen.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/list_screen.dart';
import 'screens/register_link_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await setup();
  } on TimeoutException catch (ex) {
    runApp(MyApp(
      error: true,
    ));
  }
  runApp(MyApp());
}

final getIt = GetIt.instance;
late final SharedPreferences prefs;

Future setup() async {
  await dotenv.load(fileName: ".env");

  getIt.registerSingleton<CalendarManager>(CalendarManager());
  getIt.registerSingleton<UserManager>(UserManager());
  getIt.registerSingleton<NotificationServer>(NotificationServer());

  getIt.registerSingleton<CalendarDatabase>(CalendarDatabase());

  prefs = await SharedPreferences.getInstance();

  await getIt<CalendarDatabase>().open();
  await getIt<UserManager>().loadUsers();
}

class MyApp extends StatefulWidget {
  MyApp({super.key, bool error = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _messageHanlder(RemoteMessage message) async {
    String id = message.data["notificationId"]!;
    if (getIt<UserManager>().activeUser!.notificationId == id) {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(const SnackBar(
        content: Text('Neuer Dienstplan verfügbar!'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) {
      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        getIt<NotificationServer>().updateToken(fcmToken);
      });
      FirebaseMessaging.onMessage.listen(_messageHanlder);

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, "/loading", (route) => false);
        getIt<UserManager>().setActiveUser(message.data["notificationId"]);
        Navigator.pushReplacementNamed(navigatorKey.currentContext!, "/list");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dienstplan',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
          dialogBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
          bottomSheetTheme: Theme.of(context).bottomSheetTheme.copyWith(
                backgroundColor: const Color.fromARGB(255, 10, 10, 10),
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
      debugShowCheckedModeBanner: false,
      routes: {
        '/registerLink': (context) => RegisterLinkScreen(),
        '/list': (context) => const ListScreen(),
        "/settings": (context) => const MenuScreen(),
        "/list/details": (context) => const ServiceDetailScreen(),
        "/list/all": (context) => const AllServiceScreen(),
        "/dienstplan/list": (context) => const DienstplanScreen(),
        "/loading": (context) => const LoadingScreen(),
      },
      initialRoute: prefs.containsKey("userId")
          ? "/list"
          : getIt<UserManager>().users.isEmpty
              ? "/registerLink"
              : "/dienstplan/list",
    );
  }
}
