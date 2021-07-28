import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_from_social_media/screens/download_screen.dart';
import 'package:save_from_social_media/screens/downloaded%20video%20screen.dart';
import 'package:save_from_social_media/widgets/menucard.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Insta & FB video downloader '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            MenuCard(title: 'Facebook\nDownloader',
              function: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DownloadScreen(decideDownloadRoute: true,))); // true for facebook route
              } ,
              stringIcon: 'assets/icons/fbicon.svg',
            //   icon:  Icon(Icons.facebook_sharp,
            //   size: 50,
            //   color: Colors.blue,
            // ),

            ),
        MenuCard(title: 'Instagram\nDownloader',
          function: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DownloadScreen(decideDownloadRoute: false,))); //false to head toward instagram download screen
          } ,
          stringIcon: 'assets/icons/igicon.svg',
          //   icon:  Icon(Icons.facebook_sharp,
          //   size: 50,
          //   color: Colors.blue,
          // ),
        ),
            MenuCard(title: 'downloaded\nVideos',
              function: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DownloadedVideo())); //false to head toward instagram download screen
              } ,
              stringIcon: 'assets/icons/videogallery.svg',
              //   icon:  Icon(Icons.facebook_sharp,
              //   size: 50,
              //   color: Colors.blue,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

