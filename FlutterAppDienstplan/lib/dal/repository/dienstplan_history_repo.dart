import 'package:dienstplan/helpers/utils.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DienstplanHistoryRepo {
  final Database db;

  DienstplanHistoryRepo(this.db);

  Future<void> insert(Service service) async {
    await db.insert("dienstplanHistory", service.toMap(includeUid: true, includeUserId: true));
  }

  Future<List<Service>> queryPredecessors(User user, Service service) async {
    List res = await db.query("dienstplanHistory", where: "uid=? and userId=?", whereArgs: [service.uid, user.userId]);
    List<Service> services = dbToObjects(res);

    return services;
  }

  Future<void> delete({String where = "", List args = const []}) async {
    await db.delete("dienstplanHistory", where: where, whereArgs: args);
  }


}
