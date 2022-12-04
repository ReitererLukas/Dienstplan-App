import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
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

  @computed
  bool get archive => activeUser!.archive;

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
    // getIt<CalendarManager>().loadList();
  }

  @action
  Future<void> switchArchiveMode() async {
    activeUser!.archive = !activeUser!.archive;
    await getIt<CalendarDatabase>().switchArchiveMode(activeUser!.archive);

    if(!activeUser!.archive) {
      await getIt<CalendarManager>().removeServicesFromActiveUser();
    }

  }

  @action
  Future<User> addUser(User user) async {
    await user.addToDb();
    users.add(user);
    switchUser(user);
    return user;
  }

  @action
  Future<void> removeUser() async {
    await activeUser!.delete();
    users.removeWhere((user) => user.userId == activeUser!.userId);
    activeUser = null;
  }
}
