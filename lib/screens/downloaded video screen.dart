import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_file/open_file.dart';

var path = '/storage/emulated/0/Movies/fb insta downloader';
Directory dir = Directory(path);

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
                    child: ListTile(
                      leading: SvgPicture.asset('assets/icons/video.svg'),
                      title: Text('$fileName'),
                      onTap: (){
                        OpenFile.open(file.path,type: "video/mp4");
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
