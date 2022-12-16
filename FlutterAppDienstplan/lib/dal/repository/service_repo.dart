import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/car_types.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:sqflite/sqflite.dart';

class ServiceRepo {
  final Database db;

  ServiceRepo(this.db);

  Future<List<Service>> queryAll() async {
    List res = await db.query("dienstplan", where: "userId=?", whereArgs: [getIt<UserManager>().userId]);
    List<Service> services = _rowsToObjects(res);

    return services;
  }

  Future<List<Service>> queryAllActive() async {
    List res = await db.query("dienstplan", where: "active=? AND userId=?",whereArgs: [1, getIt<UserManager>().userId]);
    return _rowsToObjects(res);
  }

  Future<List<Service>> queryAllActiveWithUserId(int userId) async {
    List res = await db.query("dienstplan", where: "active=? AND userId=?",whereArgs: [1, userId]);
    return _rowsToObjects(res);
  }

  Future<void> setAllInactive() async {
    await db.update("dienstplan", {"active": 0}, where: "userId=?", whereArgs: [getIt<UserManager>().userId]);
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
      "userId": getIt<UserManager>().userId,
    });
  }

  Future<List<Service>> getPredecessors(Service service) async {
    List<String> possibleCarTypes = CarType.values.map((e) => e.value).where((e) => e != "OTHER").toList();

    String query =  "SELECT * FROM dienstplan WHERE startTime = ? AND active = ? AND userId=? AND carType in (${List.filled(possibleCarTypes.length, '?').join(',')})";
    if(CarType.get(service.carType) == CarType.other) {
      query =  "SELECT * FROM dienstplan WHERE startTime = ? AND active = ? AND userId=? AND carType not in (${List.filled(possibleCarTypes.length, '?').join(',')})";
    }

    List args = [
      service.start.toIso8601String(),
      0,
      getIt<UserManager>().userId
    ];
    args.addAll(possibleCarTypes);

    List res = await db.rawQuery(
        query, args);
    return _rowsToObjects(res);
  }

  Future<void> setServiceActive(int id) async {
    await db.rawUpdate("UPDATE dienstplan SET active=1 WHERE id=?", [id]);
  }

  List<Service> _rowsToObjects(List res, {bool sort=true}) {
    List<Service> services = [];
    for (Map<String, dynamic> s in res) {
      services.add(Service.fromDB(s));
    }

    if(sort) {
      services.sort((a, b) {
        if(a.start.compareTo(b.start) == 0) {
          return b.timeStamp.compareTo(a.timeStamp);
        }
        return a.start.compareTo(b.start);
      });
    }
    return services;
  }

  Future<void> delete({String where = "", List args = const []}) async {
    await db.delete("dienstplan", where: where, whereArgs: args);
  }
}
