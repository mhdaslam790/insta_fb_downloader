
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class VideoItem extends StatefulWidget {
  String video;
  String name;

   VideoItem({Key? key,required this.video,required this.name}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
 late String filePath;
 late String fileName;
 late Future futureThumbnail;

 Future<Uint8List?> getThumbnail() async {
   Uint8List? unit8List = await VideoThumbnail.thumbnailData(
     video: filePath,
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
   filePath = widget.video;
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
                height: 100, width: 50, child: Image.memory(snapshot.data));
          } else {
            return SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator());
          }
        },
      ),
      title: Text('$fileName'),
      onTap: (){
        OpenFile.open(filePath,type: "video/mp4");
      },
    );
  }
}

