import 'package:flutter/material.dart';

class DienstplanAppBar extends AppBar {
  DienstplanAppBar(context, {super.key, showSettings = true, arrowBack = true})
      : super(title: const Text("Dienstplan"), actions: [
          showSettings
              ? IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/settings"),
                  icon: const Icon(Icons.settings))
              : Container()
        ], automaticallyImplyLeading: arrowBack);
}
