import 'package:dienstplan/dal/repository/dienstplan_history_repo.dart';
import 'package:dienstplan/dal/repository/dienstplan_repo.dart';
import 'package:dienstplan/dal/repository/user_repo.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class CalendarDatabase {
  late final Database db;
  late final UserRepo userRepo;
  late final DienstplanRepo dienstplanRepo;
  late final DienstplanHistoryRepo dienstplanHistoryRepo;

  Future<void> open() async {
    db = await openDatabase('dienstplan.db', version: 1,
        onUpgrade: ((db, oldVersion, newVersion) async {
      var batch = db.batch();

      if (oldVersion < 1) {
        // db is empty -> not created
        batch.execute(
            "CREATE TABLE user(userId INTEGER PRIMARY KEY, name TEXT, link TEXT, archive INTEGER, notificationId TEXT)");
        batch.execute(
            "CREATE TABLE dienstplan(uid TEXT, members TEXT, startTime TEXT, endTime TEXT, location TEXT, carType TEXT, timestamp TEXT, removedAt String, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(userId), PRIMARY KEY(uid, userId))"
                "");
        batch.execute(
            "CREATE TABLE dienstplanHistory(uid TEXT, members TEXT, startTime TEXT, endTime TEXT, location TEXT, carType TEXT, timestamp TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(userId),FOREIGN KEY(uid) REFERENCES dienstplan(uid), PRIMARY KEY(uid, timestamp, userId))");
      }

      await batch.commit();
    }), onDowngrade: onDatabaseDowngradeDelete);

    userRepo = UserRepo(db);
    dienstplanRepo = DienstplanRepo(db);
    dienstplanHistoryRepo = DienstplanHistoryRepo(db);
  }

  Future<void> updateServicesInDatabase(
      User user, List<Service> services) async {
    DateTime? maxOldTimestamp = await dienstplanRepo.findMaxTimestamp(user);
    for (Service newService in services) {
      await updateService(user, newService);
    }

    // set removedAt at all dienste where endTime is in the future
    // services list is not empty
    if(maxOldTimestamp != null) {
      await dienstplanRepo.update(
          {"removedAt": services.first.timestamp.toIso8601String()},
          where: "timestamp=? AND userId=?",
          whereArgs: [maxOldTimestamp.toIso8601String(), user.userId]);
    }
  }

  Future<Service> updateService(User user, Service service) async {
    List<Service> res = await dienstplanRepo.queryCustom(
        where: "uid=? AND userId=?", whereArgs: [service.uid, user.userId]);

    if (res.isEmpty) {
      await dienstplanRepo.insertService(service);
    } else {
      Service oldService = res.first;
      if (oldService == service) {
        await dienstplanRepo.update(
            {"timestamp": service.timestamp.toIso8601String(), "removedAt": null},
            where: "uid=? and userId=?",
            whereArgs: [oldService.uid, user.userId]);
      } else {
        await dienstplanRepo
            .update(service.toMap(), where: "uid=? and userId=?", whereArgs: [service.uid, user.userId]);
        await dienstplanHistoryRepo.insert(oldService);
      }
    }
    service.addPredecessors(
        await dienstplanHistoryRepo.queryPredecessors(user, service));
    return service;
  }

  Future<List<Service>> fetchStoredServices(User user) async {
    return await dienstplanRepo.queryActiveStoredServices(user);
  }

  Future<List<Service>> fetchAllServices(User user) async {
    List<Service> services = await dienstplanRepo.queryAll(user);

    for (Service service in services) {
      service.addPredecessors(
          await dienstplanHistoryRepo.queryPredecessors(user, service));
    }
    return services;
  }

  Future<void> removeServicesFromUser(User user) async {
    await dienstplanHistoryRepo.delete(
        where: "userId=?",
        args: [user.userId]);
    await dienstplanRepo.delete(where: "userId=?", args: [user.userId]);
  }

  Future<void> addUser(User user) async {
    await userRepo.insertUser(user);
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    return (await userRepo.queryUsers(where: "userId=?", args: [userId])).first;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await userRepo.queryUsers();
  }

  Future<void> deleteUser(int userId) async {
    await userRepo.deleteUser(userId);
  }

  Future<int> numberOfServicesFromUser(User user) async {
    return (await dienstplanRepo.queryActiveStoredServices(user)).length;
  }

  Future<void> switchArchiveMode(User user, bool newMode) async {
    await userRepo.updateUser(user.userId, {"archive": newMode ? 1 : 0});
  }

  Future<void> setNotificationId(User user, String id) async {
    user.notificationId = id;
    await userRepo.updateUser(user.userId, {"notificationId": id});
  }
}
