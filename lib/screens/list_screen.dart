import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/lists/service_list_element.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/screens/arguments/service_screen_arguments.dart';
import 'package:dienstplan/stores/calendar_manager.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DienstplanAppBar(stateOfScreen: this),
      body: Builder(
        builder: (context) {
          if (getIt<CalendarManager>().services.isEmpty) {
            return FutureBuilder(
              future: getIt<CalendarManager>().loadList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return buildList();
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return buildList();
        },
      ),
    );
  }

  Widget buildList() {
    return RefreshIndicator(
      onRefresh: () async => getIt<CalendarManager>().loadList(),
      child: Observer(
        builder: (context) {
          if (getIt<CalendarManager>().services.isNotEmpty) {
            return ListView(
              children: buildListViewElements(context),
            );
          }
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(child: Text("Keine Dienste gefunden!")),
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildListViewElements(context) {
    List<Widget> elements = [];
    for (Service service in getIt<CalendarManager>().services) {
      elements.add(
        GestureDetector(
          onTap: () => onTap(context, service),
          child: ServiceListElement(service),
        ),
      );
    }

    if (getIt<UserManager>().archive) {
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
