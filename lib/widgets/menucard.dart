import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MenuCard extends StatelessWidget {
  late String title;
  //Icon icon;
  String stringIcon;
  late Function() function;
  MenuCard({required this.title,required this.function,required this.stringIcon});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: function,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                     SvgPicture.asset(stringIcon,
                     height: 80,),
                      SizedBox(
                        height: 10,
                      ),
                      Text(title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 3,)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}