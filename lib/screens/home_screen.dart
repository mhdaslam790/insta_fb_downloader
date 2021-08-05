import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_from_social_media/screens/download_screen.dart';
import 'package:save_from_social_media/screens/downloaded%20video%20screen.dart';
import 'package:save_from_social_media/screens/helpscreen.dart';
import 'package:save_from_social_media/services/admob_service.dart';
import 'package:save_from_social_media/widgets/menucard.dart';
import 'package:save_from_social_media/widgets/navigationbarAd.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdMobService _adMobService =AdMobService();
  @override
  void initState() {
    // TODO: implement initState
    _adMobService.createInterstitialAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Insta & FB video downloader '),
          actions: <Widget>[
            IconButton(
                onPressed: ()  {

                  _adMobService.showIntAd();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HelpScreen()));
                },
                icon: Icon(Icons.help_outline_outlined))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                MenuCard(
                  title: 'Facebook\nDownloader',
                  function: () {
                    _adMobService.showIntAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DownloadScreen(
                              decideDownloadRoute: true,
                            ))); // true for facebook route
                  },
                  stringIcon: 'assets/icons/fbicon.svg',
                  //   icon:  Icon(Icons.facebook_sharp,
                  //   size: 50,
                  //   color: Colors.blue,
                  // ),
                ),
                MenuCard(
                  title: 'Instagram\nDownloader',
                  function: () {
                    _adMobService.showIntAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DownloadScreen(
                              decideDownloadRoute: false,
                            ))); //false to head toward instagram download screen
                  },
                  stringIcon: 'assets/icons/igicon.svg',
                  //   icon:  Icon(Icons.facebook_sharp,
                  //   size: 50,
                  //   color: Colors.blue,
                  // ),
                ),
                MenuCard(
                  title: 'Downloaded\nVideos',
                  function: () {
                    _adMobService.showIntAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DownloadedVideo())); //false to head toward instagram download screen
                  },
                  stringIcon: 'assets/icons/videogallery.svg',
                  //   icon:  Icon(Icons.facebook_sharp,
                  //   size: 50,
                  //   color: Colors.blue,
                  // ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:NavigationBarAd(width: 320,height: 50,)
    );
  }
}

