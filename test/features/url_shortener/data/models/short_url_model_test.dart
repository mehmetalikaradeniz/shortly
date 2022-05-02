import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';

void main(){
  ShortUrl shortUrl = ShortUrlModel(
      ok: true,
      result: const ShortUrlResultModel(
          code: "mQpaT",
          shortLink: "shrtco.de/mQpaT",
          fullShortLink: "https://shrtco.de/mQpaT",
          shortLink2: "9qr.de/mQpaT",
          fullShortLink2: "https://9qr.de/mQpaT",
          shortLink3: "shiny.link/mQpaT",
          fullShortLink3: "https://shiny.link/mQpaT",
          shareLink: "shrtco.de/share/mQpaT",
          fullShareLink: "https://shrtco.de/share/mQpaT",
          originalLink: "http://example.org/very/long/link.html"
      )
  );
  Map<String, dynamic> json = jsonDecode(File('test/jsonData/short_url.json').readAsStringSync());

  test('should be subclass of ShortUrl',
      () async {
        expect(shortUrl, isA<ShortUrl>());
      }
  );

  test('fromJson should return valid model',
      () async {
          Map<String, dynamic> json = jsonDecode(File('test/jsonData/short_url.json').readAsStringSync());
          expect(ShortUrlModel.fromJson(json), shortUrl);
      }
  );

  test('toJson should return valid map',
      () async {

        Map<String, dynamic> jsonData =  shortUrl.toJson();
        expect(jsonData, json);
      }
  );


}