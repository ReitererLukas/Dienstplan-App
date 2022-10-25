import 'package:dienstplan/dal/repository/service_repo.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:flutter/cupertino.dart';

class CalendarDatabase {
  Future<void> loadDatabase() async {}

  Future<void> updateDatabase(List<Service> services) async {
    await getIt<ServiceRepo>().setAllInactive();

    for (Service s in services) {
      await updateService(s);
    }
  }

  Future<Service> updateService(Service service) async {
    List<Service> res = await getIt<ServiceRepo>().queryCustom(
        "SELECT * FROM dienstplan WHERE startTime = ?",
        paras: [service.start.toIso8601String()]);

    if (res.isEmpty) {
      await getIt<ServiceRepo>().insertService(service);
    } else {
      Service newestService = res.firstWhere((s) =>
          s.timeStamp ==
          res
              .map<DateTime>((e) => e.timeStamp)
              .reduce((e1, e2) => e1.isAfter(e2) ? e1 : e2));

      if (!service.equalTo(newestService)) {
        await getIt<ServiceRepo>().insertService(service);
      } else {
        service.id = newestService.id;
        await getIt<ServiceRepo>().setServiceActive(newestService.id);
      }
    }
    service.addPredecessors(await getIt<ServiceRepo>().getPredecessors(service));
    return service;
  }

  Future<void> reset() async {
    await getIt<ServiceRepo>().clearTable();
  }

  Future<List<Service>> fetchServices() async {
    return await getIt<ServiceRepo>().queryAllActive();
  }
}
