import 'package:dienstplan/main.dart';
import 'package:dienstplan/stores/user_manager.dart';

class Service {
  final List<String> members;
  final DateTime startTime, endTime, timestamp;
  final String location;
  final String carType;
  final String uid;
  DateTime? removedAt;
  List<Service> predecessors = [];

  Service(this.uid, this.members, this.startTime, this.endTime, this.location,
      this.carType, this.timestamp,
      {removeAt});

  @override
  bool operator ==(Object other) {
    if (other is! Service) {
      return false;
    }
    return members.reduce((e1, e2) => "$e1, $e2").replaceAll(" ", "") ==
            other.members.reduce((e1, e2) => "$e1, $e2").replaceAll(" ", "") &&
        startTime.compareTo(other.startTime) == 0 &&
        endTime.compareTo(other.endTime) == 0 &&
        location == other.location &&
        carType == other.carType;
  }

  void addPredecessors(List<Service> predecessors) {
    this.predecessors.addAll(predecessors);
  }

  static Service fromCalendar(Map<String, dynamic> map) {
    return Service(
      map["uid"],
      map['description']!.split(","),
      DateTime.parse(map['dtstart']!),
      DateTime.parse(map['dtend']!),
      map["location"]!,
      map["summary"]!,
      DateTime.parse(map['dtstamp']!),
    );
  }

  static Service fromDB(Map<String, dynamic> map) {
    return Service(
      map["uid"],
      map['members']!.split(","),
      DateTime.parse(map['startTime']!),
      DateTime.parse(map['endTime']!),
      map["location"]!,
      map["carType"]!,
      DateTime.parse(map['timestamp']!),
      removeAt: DateTime.tryParse(map['removedAt'] ?? ''),
    );
  }

  Map<String, dynamic> toMap(
      {includeRemovedAt = false, includeUserId = false, includeUid = false}) {
    Map<String, dynamic> map = {
      "members": members.reduce((e1, e2) => "$e1,$e2"),
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
      "timestamp": timestamp.toIso8601String(),
      "location": location,
      "carType": carType,
    };
    if (includeUid) {
      map["uid"] = uid;
    }
    if (includeRemovedAt && removedAt != null) {
      map["removedAt"] = removedAt;
    }
    if (includeUserId) {
      map["userId"] = getIt<UserManager>().userId;
    }

    return map;
  }
}
