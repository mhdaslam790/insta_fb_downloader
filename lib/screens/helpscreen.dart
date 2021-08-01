import 'package:flutter/material.dart';
import 'package:save_from_social_media/widgets/navigationbarAd.dart';
import '../widgets/helpscreentextbody.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('How to Download'),
          bottom: TabBar(tabs: [
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Facebook'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Instagram'),
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    HelpScreenTextBody(
                      title: 'Open Facebook and click "Copy Link" ',
                      digit: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset('assets/images/facebookhelp.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title:
                          'Open Insta Fb downloader and click on "Facebook Downloader"',
                      digit: 2,
                    ),
                    Image.asset('assets/images/fbclick.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title: 'Click on "Paste Link"',
                      digit: 3,
                    ),
                    Image.asset('assets/images/pasteLink.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title: 'Click on "Download"',
                      digit: 4,
                    ),
                    Image.asset('assets/images/fbdownload.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    HelpScreenTextBody(
                      title: 'Open Instagram and click "Copy Link" ',
                      digit: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset('assets/images/facebookhelp.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title:
                          'Open Insta Fb downloader and click on "Instagram Downloader"',
                      digit: 2,
                    ),
                    Image.asset('assets/images/igclick.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title: 'Click on "Paste Link"',
                      digit: 3,
                    ),
                    Image.asset('assets/images/pasteLink.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                    HelpScreenTextBody(
                      title: 'Click on "Download"',
                      digit: 4,
                    ),
                    Image.asset('assets/images/igDownload.jpg',
                        width: MediaQuery.of(context).size.width - 100),
                    Divider(
                      height: 30,
                      thickness: 2,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBarAd(width: 320,height: 50,),
      ),
    );
  }
}
