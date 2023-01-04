import 'package:dienstplan/components/style/border.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogWithInput extends Dialog {
  final String text;
  final TextEditingController inputController = TextEditingController();

  ConfirmationDialogWithInput({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // icon: const Icon(Icons.warning, color: Colors.yellowAccent, size: 50),
      title: Text(text),
      content: TextField(controller: inputController, decoration: textFieldBorderDecoration(hintT: "Dev Password")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, [null]),
            child: const Text("Zurück")),
        TextButton(onPressed: () => Navigator.pop(context, [inputController.text]),
            child: const Text("Weiter")),
      ],
    );
  }
}
