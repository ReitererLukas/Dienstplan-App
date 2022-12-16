import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/main.dart';

class User {
  int userId;
  final String name, link;
  bool archive;
  String notificationId;

  User(
      {this.userId = 0,
      required this.name,
      required this.link,
      this.archive = true,
      this.notificationId = ""});

  static _fromDb(Map<String, dynamic> map) {
    return User(
        name: map["name"],
        link: map["link"],
        userId: map["userId"],
        archive: map["archive"] == 1 ? true : false,
        notificationId: map["notificationId"]);
  }

  static Future<User> findById(int userid) async {
    Map<String, dynamic> map =
        await getIt<CalendarDatabase>().getUserById(userid);

    return _fromDb(map);
  }

  Future<void> addToDb() async {
    if (userId == 0) {
      await getIt<CalendarDatabase>().addUser(this);
    }
  }

  static Future<List<User>> findAll() async {
    List<User> users = [];
    for (Map<String, dynamic> u
        in await getIt<CalendarDatabase>().getAllUsers()) {
      users.add(_fromDb(u));
    }
    return users;
  }

  Future<void> delete() async {
    await getIt<CalendarDatabase>().deleteUser(userId);
  }
}
