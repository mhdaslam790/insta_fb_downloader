import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_from_social_media/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Directory dir = Directory('/storage/emulated/0/Fb&InstaDownload');
  void createDirectory()
  {
    if(!dir.existsSync())
    {
      new Directory(dir.path).create()
      // The created directory is returned as a Future.
          .then((Directory directory) {
        print("in direct function ${directory.path}");
      });
    }
    else
    {
      print('already created');
    }
  }
  @override
  void initState() {
    createDirectory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF344955),
        scaffoldBackgroundColor:Color(0xFFEAECEF),
        accentColor: Colors.white,
        textTheme:  TextTheme(
          headline1: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black ),
          headline2: TextStyle(height: 2,fontSize: 12,color: Colors.black ),

        ),
      ),
      // darkTheme: ThemeData.dark().copyWith(
      //     primaryColor: Color(0xFF090E110),
      //     accentColor: Color(0xFF323739),
      //     scaffoldBackgroundColor: Color(0xFF0C0D0E),
      //     textTheme: TextTheme(
      //       headline1: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white70),
      //       headline2: TextStyle(height: 2,fontSize: 12,color: Colors.white70 ),
      //     )
      // ),
      home: HomeScreen(),
    );
  }
}


