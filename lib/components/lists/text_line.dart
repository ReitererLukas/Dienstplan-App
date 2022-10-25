import 'package:flutter/material.dart';

class TextLine extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  final bool isActive;
  final bool isToday;
  final bool isTomorrow;

  final int predecessors;
  final String timestamp;

  const TextLine(this.text, this.textStyle,
      {super.key,
      this.isActive = false,
      this.isToday = false,
      this.isTomorrow = false,
      this.predecessors = 0,
      this.timestamp = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                text,
                style: textStyle,
              ),
            ),
            badge()
          ],
        ),
        repeat()
      ],
    );
  }

  Widget repeat() {
    const Color font = Color.fromARGB(255, 156, 156, 156);
    if (predecessors > 0) {
      return Container(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            const Icon(
              Icons.repeat_rounded,
              size: 15,
              color: font,
            ),
            Text(
              "$predecessors",
              style: const TextStyle(
                  fontSize: 15, color: font, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      );
    } else if (predecessors == -1) {
      return Container(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          timestamp,
          style: const TextStyle(
              fontSize: 15, color: font, fontWeight: FontWeight.normal),
        ),
      );
    }
    return Container();
  }

  Widget badge() {
    String text = "";
    Color color = Colors.orange;
    if (isTomorrow) {
      text = "Morgen";
    } else if (isActive) {
      text = "Jetzt";
      color = Colors.green;
    } else if (isToday) {
      text = "Heute";
      color = const Color.fromARGB(255, 54, 143, 61);
    }
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 1),
      padding: isToday || isActive || isTomorrow
          ? const EdgeInsets.fromLTRB(4, 1, 4, 1)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          color: color),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
