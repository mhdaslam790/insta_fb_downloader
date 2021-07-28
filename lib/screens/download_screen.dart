import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:save_from_social_media/widgets/downloadscreenbutton.dart';
import 'package:flutter/services.dart';


class DownloadScreen extends StatefulWidget {
  final bool decideDownloadRoute;
  const DownloadScreen({Key? key,required this.decideDownloadRoute}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> with SingleTickerProviderStateMixin{
  final myController = TextEditingController();
  late final String url;
   bool loading = false;
  double progress = 0.0;
  final Dio dio =Dio();
  DateTime now = DateTime.now();
  late  String videoLink;
  late  bool routePath;
  late bool enableButtonAndTxtField= true;
  late bool checkUrl= false;
  late bool popScreen=false;
  late Directory directory;


  Future<bool> saveFile(String url, String fileName) async {

    try{
      if(Platform.isAndroid)
        {
          if
          (await _requestPermission(Permission.storage))
            {
              directory = (await getExternalStorageDirectory())!;

              String newPath = "";
              //'/storage/emulated/0/Android/data/com.example.save_from_social_media/files'
              List<String> folders = directory.path.split("/");
              for(int i=1; i<folders.length;i++)
                {
                  String folder = folders[i];
                  print(folder);
                  if(folder != "Android")
                    {
                      newPath += "/" +folder;
                    }
                  else
                    {
                      break;
                    }
                }
              newPath = newPath+"/Fb&InstaDownload";
              directory = Directory(newPath);
              print(directory);
            }
          else {
            return false;
          }
        }
      else
        {
          if(await _requestPermission(Permission.photos))
            {
               directory = await getTemporaryDirectory();
            }
          else
            {
              return false;
            }
        }
      if(!await directory.exists())
        {
          await directory.create(recursive: true);
        }
      if(await directory.exists())
        {
          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
          File saveFile = File(directory.path+"/$formattedDate.mp4");
          await dio.download(url, saveFile.path,onReceiveProgress: (downloaded,totalSize){
            setState(() {
              progress = downloaded/totalSize;
            });
          });
          if(Platform.isIOS)
            {
              await ImageGallerySaver.saveFile(saveFile.path,isReturnPathOfIOS: true);
            }
          return true;
        }
    }
    catch(e)
    {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async
  {
    if(await permission.isGranted)
      {
        return true;
      }
    else
      {
        var result = await permission.request();
        if(result == PermissionStatus.granted)
          {
            return true;
          }
        else
          {
          return false;
        }
      }
  }


  downloadFile( String url) async {
    setState(() {
      loading = true;
    });

    bool downloaded = await saveFile(url, '/ElephantsDream.mp4');

    //'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
    if(downloaded)
      {
        setState(() {
          popScreen = true;
        });
        print('file downloaded');
      }
    else
      {
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
          r'^(?:(?:https?:)?\/\/)?(?:www\.)?facebook\.com\/[a-zA-Z0-9\.]+\/videos\/(?:[a-zA-Z0-9\.]+)');
      final text = regExp.firstMatch(url);
      String? ftext = text!.group(0);
      print(ftext);
      var check = await DirectLink.check('https://www.facebook.com/Crunchyroll/videos/312063359759542');
       checkUrl = regExp.hasMatch(ftext!);
      print(checkUrl);
      if( checkUrl == true) {

        print(check![0].quality);
        if (check.isEmpty) {
          return;

        } else {
          videoLink = check[0].link;
          print(videoLink);
           downloadFile(videoLink);
        }
      }
    }
    catch(e)
    {
      print(e);
    }
      //https://www.facebook.com/ArcadeCloudOriginals/videos/346705332874478

  }
  Future<void> downloadInstagramvideo() async {
    print('in instagram download section');
    if(Platform.isAndroid)
    {
      if (await _requestPermission(Permission.storage))
      {
        directory = (await getExternalStorageDirectory())!;

        String newPath = "";
        //'/storage/emulated/0/Android/data/com.example.save_from_social_media/files'
        List<String> folders = directory.path.split("/");
        for(int i=1; i<folders.length;i++)
        {
          String folder = folders[i];
          print(folder);
          if(folder != "Android")
          {
            newPath += "/" +folder;
          }
          else
          {
            break;
          }
        }
        newPath = newPath+"/fbdownloadvid";
        directory = Directory(newPath);
        print(directory);
      }
      else {
        return ;
      }
    }
  }
  void updateUI(bool decideRoute)
  {
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
      appBar: AppBar(),
      body:  loading ? Column(

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
            Text('Downloading video',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ) : Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
             Container(
               margin: EdgeInsets.all(10) ,
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
                  labelText: 'Paste link here',
                ),
            ),
             ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DownloadScreenButton(
                  title: 'Paste link',
                    color: Color(0xFF4A6572),
                    function: () async { // onPress function of button
                      ClipboardData? data = await Clipboard.getData('text/plain');
                      setState(() {
                        myController.text = data!.text.toString(); // this will paste "copied text" to textFieldController
                      });
                    },
                  disEn: enableButtonAndTxtField,
                    ),
                SizedBox(width: 7,),
                DownloadScreenButton(
                  title: 'Download' ,
                  color: Color(0xFF442C2E),
                  function: () async {
                    setState(() {
                      enableButtonAndTxtField = false;
                    });
                     routePath ? await downFacebookVideo(myController.text): downloadInstagramvideo();
                    setState(() {
                      enableButtonAndTxtField = true;
                    });
                    // popScreen?Navigator.pop(context):null;
                  },
                  disEn: enableButtonAndTxtField,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


