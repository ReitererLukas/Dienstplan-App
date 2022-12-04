import 'package:dienstplan/dal/repository/service_repo.dart';
import 'package:dienstplan/dal/repository/user_repo.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/car_types.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CalendarDatabase {
  late final Database db;
  late final UserRepo userRepo;
  late final ServiceRepo serviceRepo;

  Future<void> open() async {
    db = await openDatabase('dienstplan.db', version: 1,
        onUpgrade: ((db, oldVersion, newVersion) async {
      var batch = db.batch();

      if (oldVersion < 1) {
        // db is empty -> not created
        batch.execute(
            "CREATE TABLE user(userId INTEGER PRIMARY KEY, name TEXT, link TEXT, archive INTEGER)");
        batch.execute(
            "CREATE TABLE dienstplan(id INTEGER PRIMARY KEY, members TEXT, startTime TEXT, endTime TEXT, location TEXT, carType TEXT, timestamp TEXT, active INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES user(userId))");
      }

      await batch.commit();
    }), onDowngrade: onDatabaseDowngradeDelete);

    userRepo = UserRepo(db);
    serviceRepo = ServiceRepo(db);
  }

  Future<void> updateServicesInDatabase(List<Service> services) async {
    await serviceRepo.setAllInactive();

    for (Service s in services) {
      await updateService(s);
    }
  }

  Future<Service> updateService(Service service) async {
    List<Service> res = await serviceRepo.queryCustom(
        "SELECT * FROM dienstplan WHERE startTime = ? AND userId=? AND carType=?",
        paras: [
          service.start.toIso8601String(),
          getIt<UserManager>().userId,
          service.carType,
        ]);

    if (res.isEmpty) {
      await serviceRepo.insertService(service);
    } else {
      Service newestService = res.firstWhere((s) =>
          s.timeStamp ==
          res
              .map<DateTime>((e) => e.timeStamp)
              .reduce((e1, e2) => e1.isAfter(e2) ? e1 : e2));

      if (service != newestService) {
        await serviceRepo.insertService(service);
      } else {
        service.id = newestService.id;
        await serviceRepo.setServiceActive(newestService.id);
      }
    }
    service.addPredecessors(await serviceRepo.getPredecessors(service));
    return service;
  }

  Future<List<Service>> fetchServices() async {
    return await serviceRepo.queryAllActive();
  }

  Future<List<Service>> fetchAllServices() async {
    List<Service> services = await serviceRepo.queryAll();

    List<Service> res = [];
    res.addAll(analyseServices(services.where((s) => CarType.get(s.carType) == CarType.other)));
    res.addAll(analyseServices(services.where((s) => CarType.get(s.carType) != CarType.other)));
    res.sort((a, b) {
      if(a.start.compareTo(b.start) == 0) {
        return b.timeStamp.compareTo(a.timeStamp);
      }
      return a.start.compareTo(b.start);
    });
    return res;
  }

  List<Service> analyseServices(Iterable<Service> services) {
    List<Service> res = [];
    for (Service s in services) {
      if (res.isEmpty) {
        res.add(s);
      } else {
        if (res.last.start.isAtSameMomentAs(s.start)) {
          res.last.addPredecessors([s]);
        } else {
          res.add(s);
        }
      }
    }
    return res;
  }

  Future<void> removeServicesFromUser() async {
    await serviceRepo.delete(where: "userId=?", args: [getIt<UserManager>().userId]);
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

  Future<int> numberOfServicesFromUser(int userId) async {
    return (await serviceRepo.queryAllActiveWithUserId(userId)).length;
  }

  Future<void> switchArchiveMode(bool newMode) async {
    await userRepo.updateUser(getIt<UserManager>().userId, {"archive": newMode?1:0});
  }
}
