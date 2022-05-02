import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';

import '../../domain/entities/short_url.dart';

const String sharedPreferencesKey = "cachedShortUrlList";

abstract class ShortUrlLocalDataSource{
  ShortUrlList? getShortUrlList();
  Future<void> cacheShortUrl(ShortUrlList shortUrlList);
}

class ShortUrlLocalDataSourceImpl implements ShortUrlLocalDataSource{
  late SharedPreferences sharedPreferences;
  ShortUrlLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheShortUrl(ShortUrlList shortUrlList) async{
    sharedPreferences.setString(sharedPreferencesKey, jsonEncode(shortUrlList.toJson()));
  }
  @override
  ShortUrlList? getShortUrlList() {
    String? data = sharedPreferences.getString(sharedPreferencesKey);
    Map<String, dynamic>? json = data != null ? jsonDecode(data) : null;
    return json != null ? ShortUrlListModel.fromJson(json) : null;
  }
  
}