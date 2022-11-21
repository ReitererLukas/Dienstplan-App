import 'package:flutter/material.dart';

class DienstplanAppBar extends AppBar {
  DienstplanAppBar(context, {super.key, showSettings = true, arrowBack = true, required setState})
      : super(title: const Text("Dienstplan"), actions: [
          showSettings
              ? IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/settings").then((_) => setState(() {})),
                  icon: const Icon(Icons.settings))
              : Container()
        ], automaticallyImplyLeading: arrowBack);
}
