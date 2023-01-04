import 'package:flutter/material.dart';

InputDecoration textFieldBorderDecoration({hintT = ""}) {
  return InputDecoration(
    border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    hintText: hintT,
    hintStyle: const TextStyle(
      color: Color.fromARGB(120, 255, 255, 255),
    ),
  );
}