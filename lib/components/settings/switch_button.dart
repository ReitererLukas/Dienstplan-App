import 'package:flutter/material.dart';

class SettingsSwitchButton extends StatefulWidget {
  final String text;
  final bool isOn;
  final Function action;

  const SettingsSwitchButton(
      {super.key,
      required this.text,
      required this.isOn,
      required this.action});

  @override
  State<SettingsSwitchButton> createState() => SettingsSwitchButtonState();
}

class SettingsSwitchButtonState extends State<SettingsSwitchButton> {
  bool switchState = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text),
          Switch(
            value: switchState,
            onChanged: (val) {
              setState(() => switchState = val);
              widget.action(val);
            },
          )
        ],
      ),
    );
  }
}
