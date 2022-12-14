import 'package:dienstplan/components/dialogs/confirmation_dialog.dart';
import 'package:dienstplan/components/dialogs/confirmation_dialog_with_input.dart';
import 'package:flutter/material.dart';

class SettingsSwitchButton extends StatefulWidget {
  final String text;
  bool isOn;
  final Function action;
  final bool useConfirmationDialog, useInputDialogConfirmation;
  final String confirmationDialogText;

  SettingsSwitchButton(
      {super.key,
      required this.text,
      required this.isOn,
      required this.action,
      this.useConfirmationDialog = false,
      this.confirmationDialogText = "",
      this.useInputDialogConfirmation = false});

  @override
  State<SettingsSwitchButton> createState() => SettingsSwitchButtonState();
}

class SettingsSwitchButtonState extends State<SettingsSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text),
          Switch(
            value: widget.isOn,
            onChanged: onChange
          )
        ],
      ),
    );
  }

  void onChange(bool val) {
    if (!val && widget.useConfirmationDialog) {
      showDialog(
          context: context,
          builder: ((context) => ConfirmationDialog(
              text: widget.confirmationDialogText)),
          barrierDismissible: false)
          .then((res) {
        if (res[0]) {
          setState(() => widget.isOn = val);
          widget.action(val);
        }
      });
    } else if(val && widget.useInputDialogConfirmation) {
      showDialog(
          context: context,
          builder: ((context) => ConfirmationDialogWithInput(
              text: widget.confirmationDialogText)),
          barrierDismissible: false)
          .then((res) {
        if (res[0] != null) {
          if(widget.action(res[0])) setState(() => widget.isOn = val);
        }
      });
    } else {
      setState(() => widget.isOn = val);
      widget.action(val);
    }
  }
}
