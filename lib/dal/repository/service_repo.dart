import 'package:dienstplan/models/service.dart';
import 'package:sqflite/sqflite.dart';

class ServiceRepo {
  late final Database db;

  Future<List<Service>> queryAll() async {
    List res = await db.rawQuery("SELECT * FROM dienstplan");
    return _rowsToObjects(res);
  }

  Future<List<Service>> queryAllActive() async {
    List res = await db.query("dienstplan");
    return _rowsToObjects(res);
  }

  Future<void> setAllInactive() async {
    await db.update("dienstplan", {"active": 0});
  }

  Future<List<Service>> queryCustom(String query,
      {List paras = const []}) async {
    List res = await db.rawQuery(query, paras);

    return _rowsToObjects(res);
  }

  Future<void> insertService(Service service) async {
    service.id = await db.insert("dienstplan", {
      "members": service.coWorkers.reduce((e1, e2) => "$e1, $e2"),
      "startTime": service.start.toIso8601String(),
      "endTime": service.end.toIso8601String(),
      "timestamp": service.timeStamp.toIso8601String(),
      "location": service.location,
      "carType": service.carType,
      "active": 1,
    });
  }

  Future<List<Service>> getPredecessors(Service service) async {
    List res = await db.rawQuery(
        "SELECT * FROM dienstplan WHERE startTime = ? AND active = 0",
        [service.start.toIso8601String()]);
    return _rowsToObjects(res);
  }

  Future<void> setServiceActive(int id) async {
    await db.rawUpdate("UPDATE dienstplan SET active=1 WHERE id=?", [id]);
  }

  List<Service> _rowsToObjects(List res) {
    List<Service> services = [];
    for (Map<String, dynamic> s in res) {
      services.add(Service.fromDB(s));
    }
    return services;
  }

  Future<void> open() async {
    db = await openDatabase('dienstplan.db', onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE dienstplan(id INTEGER PRIMARY KEY, members TEXT, startTime TEXT, endTime TEXT, location TEXT, carType TEXT, timestamp TEXT, active INTEGER)");
    }, version: 1);
  }

  Future<void> clearTable() async {
    db.execute("DELETE FROM dienstplan");
  }
}
