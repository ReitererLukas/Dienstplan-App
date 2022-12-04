import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/dal/calendar_loader.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'calendar_manager.g.dart';

// This is the class used by rest of your codebase
class CalendarManager = _CalendarManager with _$CalendarManager;

abstract class _CalendarManager with Store {
  @observable
  List<Service> services = [];

  @action
  Future<void> loadList() async {
    List<Service> services = await CalendarLoader().loadCalendar();

    services.sort((a, b) {
      if(a.start.compareTo(b.start) == 0) {
        return b.timeStamp.compareTo(a.timeStamp);
      }
      return a.start.compareTo(b.start);
    });

    if (services.isNotEmpty && getIt<UserManager>().archive) {
      await getIt<CalendarDatabase>().updateServicesInDatabase(services);
      this.services = services;
    } else if (getIt<UserManager>().archive) {
      this.services = await getIt<CalendarDatabase>().fetchServices();
    } else {
      this.services = services;
    }
  }

  Future<List<Service>> getAllServices() async {
    return await getIt<CalendarDatabase>().fetchAllServices();
  }

  @action
  void clearServiceList() {
    services.clear();
  }

  @action
  Future<void> removeServicesFromActiveUser() async {
    await getIt<CalendarDatabase>().removeServicesFromUser();
    services.clear();
  }

}
