import 'package:dienstplan/components/lists/text_line.dart';
import 'package:dienstplan/models/car_types.dart';
import 'package:dienstplan/models/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ServiceListElement extends StatelessWidget {
  final Service service;
  final NumberFormat leadingZero = NumberFormat("00");
  final Color elementColor = const Color.fromARGB(255, 37, 37, 37);
  final Color highlightColorRTW = const Color.fromARGB(255, 226, 122, 119);
  final Color highlightColorNEF = const Color.fromARGB(255, 188, 164, 252);
  final Color highlightColorBKTW = const Color.fromARGB(255, 253, 222, 168);
  final Color highlightColorOthers = const Color.fromARGB(255, 196, 196, 196);
  final bool showNumberOfPredecessors;
  final bool showBadge;

  ServiceListElement(this.service,
      {super.key, this.showNumberOfPredecessors = true, this.showBadge = true});

  @override
  Widget build(BuildContext context) {
    CarType carType = CarType.get(service.carType);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
          height: 8,
          decoration: BoxDecoration(
            color: CarType.getColor(carType),
            borderRadius:
                const BorderRadiusDirectional.vertical(top: Radius.circular(5)),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          padding: const EdgeInsets.all(5),
          color: elementColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextLine("${service.carType} ${dateToDayAndMonth(service.startTime)}",
                  textDecorator(bold: true),
                  isTomorrow: checkIsTomorrow() && showBadge,
                  isToday: checkIsToday() && showBadge,
                  isActive: checkIsActive() && showBadge,
                  timestamp: formatTimestamp(service.timestamp),
                  predecessors: showNumberOfPredecessors
                      ? service.predecessors.length
                      : -1,
                  carType: carType,),
              TextLine(
                "${formatWorkingDuration(service.startTime, service.endTime)} @${service.location}",
                textDecorator(grayscale: true),
              ),
              ![".",""].contains(coWorkers(service.members)) ?TextLine(
                coWorkers(service.members),
                textDecorator(),
              ):Container(),
            ],
          ),
        ),
      ],
    );
  }

  bool checkIsTomorrow() {
    return formatDate(DateTime.now().add(const Duration(days: 1))) ==
        formatDate(service.startTime);
  }

  bool checkIsToday() {
    return formatDate(DateTime.now()) == formatDate(service.startTime);
  }

  String formatDate(DateTime date) {
    return date.toIso8601String().split("T").first;
  }

  bool checkIsActive() {
    return DateTime.now().isAfter(service.startTime) &&
        DateTime.now().isBefore(service.endTime);
  }

  String dateToDayAndMonth(DateTime date) {
    return "${leadingZero.format(date.day)}.${leadingZero.format(date.month)} ";
  }

  String timeToHourAndMinute(DateTime date) {
    return "${leadingZero.format(date.hour)}:${leadingZero.format(date.minute)}";
  }

  String formatTimestamp(DateTime date, {onlyTime = false}) {
    return "${onlyTime ? '' : dateToDayAndMonth(date)}${timeToHourAndMinute(date)}";
  }

  String formatWorkingDuration(DateTime start, DateTime end) {
    return "${formatTimestamp(start)} - ${formatTimestamp(end, onlyTime: dateToDayAndMonth(start) == dateToDayAndMonth(end))}";
  }

  TextStyle textDecorator({bool bold = false, grayscale = false}) {
    return TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 15,
        color: grayscale
            ? const Color.fromARGB(255, 156, 156, 156)
            : const Color.fromARGB(255, 255, 255, 255),
        fontWeight: bold ? FontWeight.bold : FontWeight.normal);
  }

  String coWorkers(List<String> list) {
    return list
        .map((e) => e.replaceAll(r"\", ""))
        .reduce((e1, e2) => "$e1,$e2");
  }
}
