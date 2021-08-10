import 'dart:io';
import 'package:flutter/material.dart';
import 'package:save_from_social_media/widgets/videoitem.dart';

var path = '/storage/emulated/0/Movies/fb insta downloader';
Directory dir = Directory(path);
Directory thumbDir = Directory('/storage/emulated/0/.saveit/.thumb');

class DownloadedVideo extends StatefulWidget {
  const DownloadedVideo({Key? key}) : super(key: key);

  @override
  _DownloadedVideoState createState() => _DownloadedVideoState();
}

class _DownloadedVideoState extends State<DownloadedVideo> {
  var fileList;
  bool checkFileExist = false;

  void direct() async {
    setState(() {
      if (Platform.isAndroid) {
        if ((dir.listSync().length) > 0) {
          print('exist');
          fileList = dir.listSync();
          checkFileExist = true;
        } else {
          print("file not exist");
        }
      } else {
        print('check your ios gallery for download f ile');
      }
    });
  }

  @override
  void initState() {
    direct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: !checkFileExist
          ? Center(
              child: Text(
                Platform.isAndroid
                    ? 'Sorry, No Downloads Found!'
                    : 'check your photos app for downloaded video',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: fileList.length,
                itemBuilder: (context, index) {
                  File file = fileList[index];
                  String fileName = file.path.split('/').last;
                  return Card(
                    child: VideoItem(video: file.path, name: fileName),
                  );
                },
              ),
            ),
    );
  }
}
