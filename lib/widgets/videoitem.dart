import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class VideoItem extends StatefulWidget {
  File file;
  String name;

   VideoItem({Key? key,required this.file,required this.name}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
 late File file;
 late String fileName;
 late Future futureThumbnail;

 Future<Uint8List?> getThumbnail() async {
   Uint8List? unit8List = await VideoThumbnail.thumbnailData(
     video: file.path,
     imageFormat: ImageFormat.JPEG,
     maxWidth: 128,
     quality: 20,
   );
   return unit8List;
 }

 @override
  void initState() {
    // TODO: implement initState
   fileName = widget.name;
   file = widget.file;
    super.initState();
   futureThumbnail = getThumbnail();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder<dynamic>(
        future: futureThumbnail,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black
              ),
                height: 160, width: 80, child: Image.memory(snapshot.data));
          } else {
            return SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator());
          }
        },
      ),
      title: Text('$fileName'),
      onTap: (){
        showDialog(context: context, builder: (context) => Dialog(
          child: Container(
            padding:  EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    title: Text("Open"),
                    onTap: () {
                      OpenFile.open(file.path,type: "video/mp4");
                      Navigator.pop(context);
                    }),
                // if(await checkSDK())
                // ListTile(
                //     title: Text("Delete"),
                //     onTap: () {
                //       setState(() {
                //         file.delete();
                //       });
                //
                //       Navigator.pushReplacement(context, MaterialPageRoute(
                //           builder: (context) =>
                //               DownloadedVideo()));
                //     }),
                ListTile(
                    title: Text("Share"),
                    onTap: () {
                      Share.shareFiles([file.path],text: 'sharing file');
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        ));
      },
    );
  }
}

