import 'package:dienstplan/components/app_bar.dart';
import 'package:dienstplan/components/lists/service_list_element.dart';
import 'package:dienstplan/models/service.dart';
import 'package:dienstplan/screens/arguments/service_screen_arguments.dart';
import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Service service =
        (ModalRoute.of(context)!.settings.arguments as ServiceScreenArguments)
            .service;

    return Scaffold(
        appBar: DienstplanAppBar(context),
        body: Column(
          children: buildColumn(service),
        ));
  }

  List<Widget> buildColumn(Service service) {
    List<Widget> column = [];
    column.addAll(
      [
        ServiceListElement(
          service,
          showNumberOfPredecessors: false,
        ),
        const Divider(
          indent: 5,
          endIndent: 5,
          color: Colors.grey,
          thickness: 2,
        ),
        const Text("Alte Versionen"),
      ],
    );

    for (Service s in service.predecessors) {
      column.add(ServiceListElement(
        s,
        showBadge: false,
        showNumberOfPredecessors: false,
      ));
    }

    return column;
  }
}
