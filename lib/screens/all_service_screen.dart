import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/lists/service_list_element.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/screens/arguments/service_screen_arguments.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:flutter/material.dart';

class AllServiceScreen extends StatefulWidget {
  const AllServiceScreen({super.key});

  @override
  State<AllServiceScreen> createState() => AllServiceScreenState();
}

class AllServiceScreenState extends State<AllServiceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(context, setState: setState,),
      body: FutureBuilder(
        future: getIt<CalendarManager>().getAllServices(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: createListViewElements(context, snapshot.data),
            );
          }
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }

  List<Widget> createListViewElements(context, services) {
    List<Widget> elements = [];
    for (Service service in services) {
      elements.add(
        GestureDetector(
          onTap: () => onTap(context, service),
          child: ServiceListElement(service, showBadge: false,),
        ),
      );
    }
    return elements;
  }

  void onTap(context, Service service) {
    if (service.predecessors.isNotEmpty) {
      Navigator.pushNamed(context, "/list/details",
          arguments: ServiceDetailScreenArguments(service));
    }
  }
}
