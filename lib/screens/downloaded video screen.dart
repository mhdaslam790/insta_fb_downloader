import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


var path='/storage/emulated/0/Fb&InstaDownload';
Directory dir = Directory(path);

class DownloadedVideo extends StatefulWidget {
  const DownloadedVideo({Key? key}) : super(key: key);

  @override
  _DownloadedVideoState createState() => _DownloadedVideoState();
}

class _DownloadedVideoState extends State<DownloadedVideo> {

  var fileList;
  bool checkFileExist=false;


  void direct() async {
    setState(()  {
      if ((dir.listSync().length) > 0) {
        print('exist');
        fileList = dir.listSync();
        checkFileExist = true;
      }
      else {
        print("file not exist");
      }
      print(dir.listSync());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    direct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('/emulated/0/Fb&InstaDownload'),
      ),
      body: !checkFileExist?Center(
        child: Text(
          'Sorry, No Downloads Found!',
          style: TextStyle(fontSize: 18.0),
        ),
      ):Container(
        child: ListView.builder(
          itemCount: fileList.length,
            itemBuilder:  (context, index){
            File file = fileList[index];
            String fileName = file.path.split('/').last;
            return Card(
              child: ListTile(
                leading: SvgPicture.asset('assets/icons/video.svg'),
                title: Text('$fileName'),
              ),
            );
            },
        ),
      ),
    );
  }
}

