import 'package:flutter/material.dart';

class HelpScreenTextBody extends StatelessWidget {
  final String title;
  final int digit;

  const HelpScreenTextBody({
    Key? key,
    required this.title,
    required this.digit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 15,
          ),
          Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.42),
              shape: BoxShape.circle,
            ),
            child: Text('$digit'),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
