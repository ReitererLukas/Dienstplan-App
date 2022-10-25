import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String text;
  final Function action;

  const SettingsButton({super.key, required this.text, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () => action(),
        style: ButtonStyle(
          alignment: Alignment.center,
          minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        ),
        child: Text(text),
      ),
    );
  }
}
