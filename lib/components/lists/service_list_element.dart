import 'package:dienstplan/components/lists/text_line.dart';
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
  final bool showNumberOfPredecessors;
  final bool showBadge;

  ServiceListElement(this.service,
      {super.key, this.showNumberOfPredecessors = true, this.showBadge = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
          height: 8,
          decoration: BoxDecoration(
            color: service.carType == "RTW"
                ? highlightColorRTW
                : service.carType == "NEF"
                    ? highlightColorNEF
                    : highlightColorBKTW,
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
              TextLine("${service.carType} ${dateToDayAndMonth(service.start)}",
                  textDecorator(bold: true),
                  isTomorrow: checkIsTomorrow() && showBadge,
                  isToday: checkIsToday() && showBadge,
                  isActive: checkIsActive() && showBadge,
                  timestamp: formatTimestamp(service.timeStamp),
                  predecessors: showNumberOfPredecessors
                      ? service.predecessors.length
                      : -1),
              TextLine(
                "${formatWorkingDuration(service.start, service.end)} @${service.location}",
                textDecorator(grayscale: true),
              ),
              TextLine(
                service.coWorkers
                    .map((e) => e.replaceAll(r"\", ""))
                    .reduce((e1, e2) => "$e1,$e2"),
                textDecorator(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool checkIsTomorrow() {
    return formatDate(DateTime.now().add(const Duration(days: 1))) ==
        formatDate(service.start);
  }

  bool checkIsToday() {
    return formatDate(DateTime.now()) == formatDate(service.end);
  }

  String formatDate(DateTime date) {
    return date.toIso8601String().split("T").first;
  }

  bool checkIsActive() {
    return DateTime.now().isAfter(service.start) &&
        DateTime.now().isBefore(service.end);
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
        fontSize: 15,
        color: grayscale
            ? const Color.fromARGB(255, 156, 156, 156)
            : const Color.fromARGB(255, 255, 255, 255),
        fontWeight: bold ? FontWeight.bold : FontWeight.normal);
  }
}
