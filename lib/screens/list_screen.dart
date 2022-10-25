import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/lists/service_list_element.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/screens/arguments/service_screen_arguments.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => getIt<CalendarManager>().loadList(),
        child: Observer(
          builder: (context) {
            if (getIt<CalendarManager>().services.isNotEmpty) {
              return ListView(
                children: createListViewElements(context),
              );
            }
            return const Center(child: Text("Keine Dienste gefunden!"));
          },
        ),
      ),
    );
  }

  List<Widget> createListViewElements(context) {
    List<Widget> elements = [];
    for (Service service in getIt<CalendarManager>().services) {
      elements.add(
        GestureDetector(
          onTap: () => onTap(context, service),
          child: ServiceListElement(service),
        ),
      );
    }
    elements.add(
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, "/list/all"),
        child: Container(
          margin: const EdgeInsets.only(top: 15, bottom: 30),
          child: const Align(
            alignment: Alignment.center,
            child: Text("Alle Dienste anzeigen"),
          ),
        ),
      ),
    );

    return elements;
  }

  void onTap(context, Service service) {
    if (service.predecessors.isNotEmpty) {
      Navigator.pushNamed(context, "/list/details",
          arguments: ServiceDetailScreenArguments(service));
    }
  }
}
