import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/notifications/notification_server.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'user_manager.g.dart';

// This is the class used by rest of your codebase
class UserManager = _UserManager with _$UserManager;

abstract class _UserManager with Store {
  @observable
  List<User> users = [];
  @observable
  User? activeUser;

  @computed
  int get userId => activeUser!.userId;

  @action
  Future<void> loadUsers() async {
    users = await User.findAll();
    if(prefs.containsKey("userId") && users.isNotEmpty) {
      List<User> us = users.where((element) => element.userId == prefs.getInt("userId")).toList();
      if(us.isNotEmpty) {
        activeUser = users.where((element) => element.userId == prefs.getInt("userId")).first;
      }
    }
  }

  @action
  void switchUser(User newUser) {
    activeUser = newUser;
    getIt<CalendarManager>().clearServiceList();
    prefs.setInt("userId", activeUser!.userId);
  }

  @action
  void setActiveUser(String notificationId) {
    switchUser(users.where((u) => u.notificationId == notificationId).first);
  }

  @action
  Future<void> switchArchiveMode() async {
    activeUser!.archive = !activeUser!.archive;
    await getIt<CalendarDatabase>().switchArchiveMode(activeUser!, activeUser!.archive);

    if(!activeUser!.archive) {
      await getIt<CalendarManager>().removeServicesFromActiveUser();
    }
  }

  @action
  Future<void> setNotificationId(String id) async {
    activeUser!.notificationId = id;
    await getIt<CalendarDatabase>().setNotificationId(activeUser!, id);
  }

  @action
  Future<User> addUser(User user) async {
    user.notificationId = await getIt<NotificationServer>().registerDienstplan(user);
    await user.addToDb();
    users.add(user);
    switchUser(user);
    return user;
  }

  @action
  Future<void> removeUser() async {
    if(activeUser!.notificationId != "") {
      getIt<NotificationServer>().removeDienstplan(getIt<UserManager>().activeUser!);
    }
    getIt<CalendarDatabase>().removeServicesFromUser(activeUser!);
    await activeUser!.delete();
    users.removeWhere((user) => user.userId == activeUser!.userId);
    activeUser = null;
  }

  @action
  Future<void> deactivateServerFeaturesForAllUsers() async {
    for(User user in users) {
      if(user.notificationId != "") {
        getIt<NotificationServer>().removeDienstplan(user);
        await getIt<CalendarDatabase>().setNotificationId(user, "");
      }
    }
  }

  @action
  Future<void> activateServerFeaturesForAllUsers() async {
    for(User user in users) {
      await getIt<CalendarDatabase>().setNotificationId(user,  await getIt<NotificationServer>().registerDienstplan(user));
    }
  }
}
