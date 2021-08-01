import 'package:dio/dio.dart';

class Networking {
  Dio dio = new Dio();

  Future<dynamic> fetchPost(String urlString) async {
    final response = await dio.get(urlString);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load post.');
    }
  }
}
