import 'dart:convert';

import '../models/short_url_model.dart';
import 'package:http/http.dart' as http;

abstract class ShortUrlRemoteDataSource{
  Future<ShortUrlModel> getShortUrl(String url);
}

class ShortUrlRemoteDataSourceImpl implements ShortUrlRemoteDataSource{
  final http.Client client;
  ShortUrlRemoteDataSourceImpl({required this.client});
  @override
  Future<ShortUrlModel> getShortUrl(String url) async{
    var uri = Uri.parse('https://api.shrtco.de/v2/shorten?url=$url');
    var response = await http.get(uri);

    return ShortUrlModel.fromJson(jsonDecode(response.body));
  }
  
}