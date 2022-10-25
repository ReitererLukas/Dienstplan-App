class Service {
  int id;
  final List<String> coWorkers;
  final DateTime start, end, timeStamp;
  final String location;
  final String carType;
  List<Service> predecessors = [];

  Service(this.coWorkers, this.start, this.end, this.location, this.carType,
      this.timeStamp,
      {this.id = 0});

  bool equalTo(Service other) {
    return coWorkers.reduce((e1, e2) => "$e1, $e2").replaceAll(" ", "") ==
        other.coWorkers.reduce((e1, e2) => "$e1, $e2").replaceAll(" ", "")
        && start.compareTo(other.start) == 0
        && end.compareTo(other.end) == 0
        && location == other.location
        && carType == other.carType;
  }

  void addPredecessors(List<Service> predecessors) {
    this.predecessors.addAll(predecessors);
  }

  static Service fromCalendar(Map<String, dynamic> map) {
    return Service(
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
      map['members']!.split(","),
      DateTime.parse(map['startTime']!),
      DateTime.parse(map['endTime']!),
      map["location"]!,
      map["carType"]!,
      DateTime.parse(map['timestamp']!),
      id: map['id']!,
    );
  }
}
