import 'package:flutter/material.dart';
// ignore: must_be_immutable
class DownloadScreenButton extends StatelessWidget {
  String title;
  Color color;
  bool disEn;
  final void Function() function;
   DownloadScreenButton({
    Key? key,required this.title,required this.color,required this.function,required this.disEn
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold)),
      onPressed: disEn? function: null,
      child: Text(title),);
  }
}