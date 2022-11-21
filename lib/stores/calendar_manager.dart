import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/dal/calendar_loader.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
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

    if (services.isNotEmpty && (prefs.getBool("useArchiver") ?? true)) {
      await getIt<CalendarDatabase>().updateDatabase(services);
      this.services = services;
    } else if ((prefs.getBool("useArchiver") ?? true)) {
      this.services = await getIt<CalendarDatabase>().fetchServices();
    } else {
      this.services = services;
    }
  }

  Future<List<Service>> getAllServices() async {
    return await getIt<CalendarDatabase>().fetchAllServices();
  }

  @action
  Future<void> clear() async {
    services.clear();
    await clearDatabase();
  }

  @action
  Future<void> clearDatabase() async {
    await getIt<CalendarDatabase>().reset();
  }
}
