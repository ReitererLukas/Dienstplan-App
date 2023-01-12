import 'package:dienstplan/dal/calendar_database.dart';
import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter/material.dart';

class DienstplanListElement extends StatelessWidget {
  final bool isActive;
  final User user;
  final Function onTap;

  const DienstplanListElement(
      {super.key,
      this.isActive = false,
      required this.user,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(user),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
            height: 4,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 196, 196, 196),
              borderRadius:
                  BorderRadiusDirectional.vertical(top: Radius.circular(5)),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            padding: const EdgeInsets.all(5),
            color: const Color.fromARGB(255, 37, 37, 37),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Text(
                        user.name.substring(0, 1),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 17),
                    )
                  ],
                ),
                getBadge(),
                FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        if (getIt<UserManager>()
                            .users
                            .where((u) => u.userId == user.userId)
                            .first
                            .archive) {
                          return Text(
                              "${snapshot.data!} ${snapshot.data == 1 ? "Dienst" : "Dienste"}");
                        }
                        return const Text("Kein Archiv");
                      }
                      return Container();
                    },
                    future: getIt<CalendarDatabase>()
                        .numberOfServicesFromUser(user)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getBadge() {
    if (isActive) {
      return Container(
        margin: const EdgeInsets.only(left: 10, bottom: 1),
        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.green),
        child: const Text(
          "Aktiv",
          style: TextStyle(fontSize: 12),
        ),
      );
    }
    return Container();
  }
}
