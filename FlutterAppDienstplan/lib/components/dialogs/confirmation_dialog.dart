import 'package:flutter/material.dart';

class ConfirmationDialog extends Dialog {
  final String text;

  const ConfirmationDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      // icon: const Icon(Icons.warning, color: Colors.yellowAccent, size: 50),
      title: Text(text),
      content: Text("Diese Änderungen können nicht mehr rückgängig gemacht werden!"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, [false]), child: const Text("Zurück")),
        TextButton(onPressed: () => Navigator.pop(context, [true]), child: const Text("Weiter")),
      ],
    );
  }
}
