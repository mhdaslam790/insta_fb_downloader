import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:save_from_social_media/screens/home_screen.dart';
import 'package:save_from_social_media/services/admob_service.dart';
import 'package:save_from_social_media/services/permission.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.intialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Directory dir = Directory('/storage/emulated/0/Movies/fb insta downloader');
  void createDirectory() async {
    if(await requestPermission(Permission.storage))
    {
    if(!dir.existsSync())
    {
    new Directory(dir.path).create()
    // The created directory is returned as a Future.
        .then((Directory directory) {
    });
    }
    else
    {
    }
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
      title: 'Insta & FB video downloader',
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
      home: HomeScreen(),
    );
  }
}


