import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:save_from_social_media/services/admob_service.dart';
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
  static const _platform = MethodChannel('MediaStoreAPI');
  AdMobService _adMobService = AdMobService();
  final _myController = TextEditingController();
  bool _loading = false;
  double _progress = 0.0;
  final Dio dio = Dio();
  DateTime now = DateTime.now();
  late String _videoUrl;
  late bool _routePath;
  late bool _enableButtonAndTxtField = true;
  late bool _checkUrl = false;
  late Directory _directory;
  var _data;
  var _text;
  var _finalUrl;
  late String _formattedDate;
  late File _savedFile;
  late String _name;
  late String _pathk;
  int _i = 0;

  Future<void> _saveFileInAndroidStorage(String name, String filePath) async {
    try {
      print("inqor... $filePath ... $name");
      await _platform.invokeMethod(
          'saveFileUsingMediaStoreAPI', {"filepath": filePath, "name": name});
      print("return from kotlin but in savefromQ function ");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<bool> _saveFileToStorage(String url) async {
    try {
      if (Platform.isAndroid || Platform.isAndroid) {
        if (await requestPermission(Permission.storage) ||
            await requestPermission(Permission.photos)) {
          _directory = await getTemporaryDirectory();
          print(_directory.path);
        } else {
          return false;
        }
      }
      if (!await _directory.exists()) {
        await _directory.create(recursive: true);
      }
      if (await _directory.exists()) {
        _pathk = _directory.path;
        _formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
        _savedFile = File(_directory.path + "/video_$_formattedDate.mp4");
        print("printing savfile PAth  ${_savedFile.path}");
        await dio.download(url, _savedFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            _progress = downloaded / totalSize;
          });
        });
        _name = "/video_$_formattedDate.mp4";
        if (Platform.isAndroid) {
          await _saveFileInAndroidStorage(_name, _pathk);
        }
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(_savedFile.path,
              isReturnPathOfIOS: true);
        }
        _savedFile.delete();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future _downloadFile(String url) async {
    setState(() {
      _loading = true;
    });

    bool downloaded = await _saveFileToStorage(url);
    print('in download function');
    if (downloaded) {
      print('file downloaded');
      _showToast(context, 'File Downloaded');
    } else {
      print('error in download');
      _showToast(context, 'Error while  Downloading file');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _downFacebookVideo(String url) async {
    if (_i <= 3) {
      try {
        RegExp regExp = RegExp(
            r'^(?:(?:https?:)?\/\/)?(?:www\.)?facebook\.com\/[a-zA-Z0-9\.]+\/(videos)\/(?:[a-zA-Z0-9\.]+)');
        _checkUrl = regExp.hasMatch(url);
        print(_checkUrl);
        if (_checkUrl == true) {
          _showToast(context, 'fetching download URL');
          _text = regExp.firstMatch(url);
          _videoUrl = _text!.group(0)!;
          var check = await DirectLink.check(_videoUrl);
          print(check);
          if (check != null) {
            print(check[0].quality);
            if (check.isEmpty) {
              _downFacebookVideo(url);
            } else {
              _videoUrl = check[0].link;
              print(_videoUrl);
              _i = 4;
              _downloadFile(_videoUrl);
            }
          }
        } else {
          _showToast(context, 'Link is not valid');
          _i = 4;
        }
      } catch (e) {
        print("facebook catch body $e");
      }
    } else {
      _showToast(context, 'The link doesn\'t contain a valid URL ');
    }
  }

  Future _downloadInstagramvideo(String url) async {
    if (_i <= 3) {
      print("in ig download section");
      try {
        RegExp regExp = RegExp(
            r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/p\/([a-zA-Z0-9_-]+)\/?|'
            r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/reel\/([a-zA-Z0-9_-]+)\/?|'
            r'^((https?):\/\/)?(www.)?instagram\.com(\/[A-Za-z0-9_.]*)?\/tv\/([a-zA-Z0-9_-]+)\/?');
        _checkUrl = regExp.hasMatch(url);
        print(_checkUrl);
        if (_checkUrl == true) {
          _showToast(context, 'fetching download URL');
          _text = regExp.firstMatch(url);
          _finalUrl = _text!.group(0)! + '?__a=1';
          print(_finalUrl);
          print('in instagram download section');
          var response = await http.get(Uri.parse(_finalUrl));
          if (response.statusCode != null) {
            print(response.statusCode);
            _data = json.decode(response.body);
            _videoUrl = _data['graphql']['shortcode_media']['video_url'];
            _i = 4;
            _downloadFile(_videoUrl);
          }
        } else {
          _showToast(context, 'Link is not valid');
          _i = 4;
        }
      } catch (e) {
        print(e);
      }
    } else {
      _showToast(context, 'The link doesn\'t contain a valid URL ');
    }
  }

  void _updateUI(bool decideRoute) {
    _adMobService.createInterstitialAd();
    setState(() {
      _routePath = decideRoute;
    });
  }

  void _showToast(BuildContext context, String str) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(str),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    _updateUI(widget.decideDownloadRoute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_routePath ? 'FB download' : 'Insta download'),
      ),
      body: _loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: _progress,
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
                        controller: _myController,
                        enabled: _enableButtonAndTxtField,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _routePath
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
                              _myController.text = data!.text.toString();
                              // this will paste "copied text" to textFieldController
                            });
                          },
                          disEn: _enableButtonAndTxtField,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        DownloadScreenButton(
                          title: 'Download',
                          color: Color(0xFF442C2E),
                          function: () async {
                            setState(() {
                              _enableButtonAndTxtField = false;
                            });

                            _adMobService.showIntAd();
                            _routePath
                                ? await _downFacebookVideo(_myController.text)
                                : await _downloadInstagramvideo(
                                    _myController.text);
                            if (_i <= 3) {
                              _i = _i + 1;
                              _routePath
                                  ? await _downFacebookVideo(_myController.text)
                                  : await _downloadInstagramvideo(
                                      _myController.text);
                            }
                            if (_i <= 3) {
                              _i = _i + 1;
                              _routePath
                                  ? await _downFacebookVideo(_myController.text)
                                  : await _downloadInstagramvideo(
                                      _myController.text);
                            }
                            if (_i <= 3) {
                              _i = _i + 1;
                              _routePath
                                  ? await _downFacebookVideo(_myController.text)
                                  : await _downloadInstagramvideo(
                                      _myController.text);
                            }
                            _i = 0;
                            setState(() {
                              _enableButtonAndTxtField = true;
                            });
                            // popScreen?Navigator.pop(context):null;
                          },
                          disEn: _enableButtonAndTxtField,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (_routePath)
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Supported Link example:\n\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black)),
                            TextSpan(
                                text: 'https://www.facebook.com/123456789/videos/123456789\n\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.grey),
                            ),
                            TextSpan(
                              text: 'https://www.facebook.com/Crunchyroll/videos/123456789\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    DisplayAd(
                      width: 320,
                      height: 250,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
