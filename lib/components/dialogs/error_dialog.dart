import 'package:flutter/material.dart';

class ErrorDialog extends Dialog {
  final String text;

  const ErrorDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error, color: Colors.red,size: 50),
      title: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Ok"))
      ],

    );
  }
}
