import 'package:dienstplan/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UserRepo {
  final Database db;

  UserRepo(this.db);

  Future<void> insertUser(User user) async {
    user.userId = await db.insert("user", {"name": user.name, "link": user.link, "archive": user.archive?1:0, "notificationId": user.notificationId,});
  }

  Future<List<Map<String, dynamic>>> queryUsers({String? where, List? args}) async {
    return await db.query("user", where: where, whereArgs: args);
  }

  Future<void> deleteUser(int userId) async {
    await db.delete("user", where: "userId=?", whereArgs: [userId]);
  }

  Future<void> updateUser(int userId, Map<String, Object> values) async {
    await db.update("user", values, where: "userId=?", whereArgs: [userId]);
  }
}