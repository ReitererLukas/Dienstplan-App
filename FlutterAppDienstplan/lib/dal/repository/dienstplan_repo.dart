import 'package:dienstplan/helpers/utils.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/car_types.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DienstplanRepo {
  final Database db;

  DienstplanRepo(this.db);

  Future<List<Service>> queryAll(User user) async {
    List res = await db.query("dienstplan", where: "userId=?", whereArgs: [user.userId]);
    return dbToObjects(res);
  }

  Future<void> update(Map<String, dynamic> values, {String where ="", whereArgs=const []}) async {
    db.update("dienstplan", values, where: where, whereArgs: whereArgs);
  }

  Future<DateTime?> findMaxTimestamp(User user) async {
    // find max timestamp
    List<DateTime> timestamps = (await db.query("dienstplan", where: "userId=?",whereArgs: [user.userId], columns: ["timestamp"], distinct: true)).map((e) => DateTime.parse("${e.values.first}")).toList();
    if(timestamps.isEmpty) {
      return null;
    }
    DateTime timestamp = timestamps.reduce((e1, e2) => e1.isAfter(e2)?e1:e2); // find max
    return timestamp;
  }

  Future<List<Service>> queryActiveStoredServices(User user) async {
    DateTime? maxTimestamp = await findMaxTimestamp(user);
    if(maxTimestamp == null) {
      return [];
    }
    List res = await db.query("dienstplan", where: "timestamp=? AND userId=?",whereArgs: [maxTimestamp.toIso8601String(), user.userId]);
    // check, remove all dienste in the past
    return dbToObjects(res).where((service) => service.endTime.isAfter(DateTime.now())).toList();
  }

  Future<List<Service>> queryCustom({String where="", List whereArgs=const []}) async {
    List res = await db.query("dienstplan", where: where, whereArgs: whereArgs);
    return dbToObjects(res);
  }

  Future<List<String>> queryUidsOfUser(User user) async {
    return (await db.query("dienstplan", where: "userId=?", whereArgs: [user.userId], distinct: true, columns: ["uid"])).map((e) => "${e.values.first}").toList();
  }

  Future<void> insertService(Service service) async {
    await db.insert("dienstplan", service.toMap(includeUserId: true, includeUid: true));
  }

  Future<void> delete({String where = "", List args = const []}) async {
    await db.delete("dienstplan", where: where, whereArgs: args);
  }
}
