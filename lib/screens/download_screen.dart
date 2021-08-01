import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:save_from_social_media/services/permission.dart';
import 'package:save_from_social_media/widgets/downloadscreenbutton.dart';
import 'package:flutter/services.dart';
import 'package:save_from_social_media/widgets/navigationbarAd.dart';
import 'package:http/http.dart' as http;


class DownloadScreen extends StatefulWidget {
  final bool decideDownloadRoute;

  const DownloadScreen({Key? key, required this.decideDownloadRoute})
      : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with SingleTickerProviderStateMixin {
  final myController = TextEditingController();
  late final myControllerTemp = TextEditingController();
  bool loading = false;
  double progress = 0.0;
  final Dio dio = Dio();
  DateTime now = DateTime.now();
  late String videoUrl;
  late bool routePath;
  late bool enableButtonAndTxtField = true;
  late bool checkUrl = false;
  late Directory directory;
  var data;
  var text;
  var finalUrl;

  Future<bool> saveFile(String url) async {
    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
           print(directory.path);
          // String newPath = "";
          // //'/storage/emulated/0/Android/data/com.example.save_from_social_media/files'
          // List<String> folders = directory.path.split("/");
          // for (int i = 1; i < folders.length; i++) {
          //   String folder = folders[i];
          //   print(folder);
          //   if (folder != "Android") {
          //     newPath += "/" + folder;
          //   } else {
          //     break;
          //   }
          // }
          // newPath = newPath + "/Movies/Fb_Insta_downloader";
          // directory = Directory(newPath);
          // print(directory);
        } else {
          return false;
        }
      } else {
        if (await requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
        File saveFile = File(directory.path + "/$formattedDate.mp4");
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        print('save file function file downloaded');
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future downloadFile(String url) async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(url);
    print('in download function');
    //'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
    if (downloaded) {
      print('file downloaded');
    } else {
      print('error in download');
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> downFacebookVideo(String url) async {
    try {
      // RegExp regExp = RegExp(r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/p\/([a-zA-Z0-9_-]+)\/?');
      // final text = regExp.firstMatch('https://www.instagram.com/p/CRvzbq6leDI/?utm_source=ig_web_copy_link');
      // String? ftext = text!.group(0)!  + '?__a=1';
      // ^(?:(?:https?:)?\/\/)?(?:www\.)?facebook\.com\/[a-zA-Z0-9\.]+\/videos\/(?:[a-zA-Z0-9\.]+\/)?([0-9]+)

      RegExp regExp = RegExp(
          r'^(?:(?:https?:)?\/\/)?(?:www\.)?facebook\.com\/[a-zA-Z0-9\.]+\/(videos)\/(?:[a-zA-Z0-9\.]+)');
      checkUrl = regExp.hasMatch(url);
      print(checkUrl);
      if(checkUrl==true) {
        text = regExp.firstMatch(url);
        videoUrl = text!.group(0)!;
        var check = await DirectLink.check(videoUrl);
        print(videoUrl);
        if (check != null) {
          print(check[0].quality);
          if (check.isEmpty) {
            return;
          } else {
            videoUrl = check[0].link;
            print(videoUrl);
            downloadFile(videoUrl);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    //https://www.facebook.com/ArcadeCloudOriginals/videos/346705332874478
  }

  Future downloadInstagramvideo(String url) async {

    //downloadFile('https://instagram.fbom44-1.fna.fbcdn.net/v/t50.2886-16/226368077_339184327904674_7440016640559613563_n.mp4?_nc_ht=instagram.fbom44-1.fna.fbcdn.net&_nc_cat=110&_nc_ohc=z9Yt32YPTQ8AX9UpNo8&edm=APfKNqwBAAAA&ccb=7-4&oe=6107245A&oh=c94ac7b8366d842e170b81d7bd252a9d&_nc_sid=74f7ba');

    try {
      RegExp regExp = RegExp(r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/p\/([a-zA-Z0-9_-]+)\/?|'
      r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/reel\/([a-zA-Z0-9_-]+)\/?|'
      r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/tv\/([a-zA-Z0-9_-]+)\/?');
      //https://www.instagram.com/p/CRvzbq6leDI/?utm_source=ig_web_copy_link[a-zA-Z0-9\.]+
      checkUrl = regExp.hasMatch(url);
      print(checkUrl);
      if(checkUrl==true)
        {
          text = regExp.firstMatch(url);
          finalUrl = text!.group(0)!  + '?__a=1';
          print(finalUrl);
          print('in instagram download section');
          var response = await http.get(Uri.parse(finalUrl));
          if(response.statusCode!=null)
          {
            print(response.statusCode);
             data = json.decode(response.body);
            videoUrl = data['graphql']['shortcode_media']['video_url'];
            downloadFile(videoUrl);
            setState(() {

              myControllerTemp.text =videoUrl;

              print(videoUrl);
            });
          }
        }
    }  catch (e) {
      // TODO
      print(e);
    }
  }

  void updateUI(bool decideRoute) {
    setState(() {
      routePath = decideRoute;
    });
  }

  @override
  void initState() {
    updateUI(widget.decideDownloadRoute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(routePath ? 'FB download' : 'Insta download'),
      ),
      body: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Downloading video',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: myController,
                        enabled: enableButtonAndTxtField,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: routePath
                              ? 'Paste Facebook link here'
                              : 'Paste Instagram link here',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 7,
                        ),
                        DownloadScreenButton(
                          title: 'Paste link',
                          color: Color(0xFF4A6572),
                          function: () async {
                            // onPress function of button
                            ClipboardData? data =
                                await Clipboard.getData('text/plain');
                            setState(() {
                              myController.text = data!.text
                                  .toString();
                              // this will paste "copied text" to textFieldController
                            });
                          },
                          disEn: enableButtonAndTxtField,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        DownloadScreenButton(
                          title: 'Download',
                          color: Color(0xFF442C2E),
                          function: () async {
                            setState(() {
                              enableButtonAndTxtField = false;
                            });
                            routePath? await downFacebookVideo(myController.text)
                             :await downloadInstagramvideo(myController.text);
                            setState(() {
                              enableButtonAndTxtField = true;
                            });

                            // popScreen?Navigator.pop(context):null;
                          },
                          disEn: enableButtonAndTxtField,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),

                   NavigationBarAd(width: 320,height: 250,)
                  ],
                ),
              ),
          ),
    );
  }
}
