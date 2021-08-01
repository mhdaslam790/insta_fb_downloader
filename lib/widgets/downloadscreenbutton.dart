import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DownloadScreenButton extends StatelessWidget {
  String title;
  Color color;
  bool disEn;
  final void Function() function;

  DownloadScreenButton(
      {Key? key,
      required this.title,
      required this.color,
      required this.function,
      required this.disEn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: color,
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: disEn ? function : null,
        child: FittedBox(fit: BoxFit.fitWidth, child: Text(title)),
      ),
    );
  }
}
