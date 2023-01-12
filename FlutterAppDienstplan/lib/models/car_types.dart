import 'package:flutter/material.dart';

enum CarType {
  rtw("RTW"),
  nef("NEF"),
  bktw("BKTW"),
  id("ID"),
  kdo("KDO"),
  other("OTHER");

  const CarType(this.value);

  final String value;

  factory CarType.get(String value) {
    if (value.toLowerCase() == "rtw") {
      return CarType.rtw;
    } else if (value.toLowerCase() == "nef") {
      return CarType.nef;
    } else if (value.toLowerCase() == "bktw-r" || value.toLowerCase() == "bktw") {
      return CarType.bktw;
    } else if (value.toLowerCase() == "id") {
      return CarType.id;
    } else if (value.toLowerCase() == "kdo") {
      return CarType.kdo;
    }

    return CarType.other;
  }

  static Color getColor(CarType carType) {
    switch (carType) {
      case CarType.rtw:
        return const Color.fromARGB(255, 226, 122, 119);
      case CarType.nef:
        return const Color.fromARGB(255, 188, 164, 252);
      case CarType.bktw:
        return const Color.fromARGB(255, 253, 222, 168);
      case CarType.id:
        return const Color.fromARGB(255, 208, 250, 200);
      case CarType.kdo:
        return const Color.fromARGB(255, 255, 255, 255);
      default:
        return const Color.fromARGB(255, 196, 196, 196);
    }
  }
}
