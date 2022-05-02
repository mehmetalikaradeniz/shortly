import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';


class ShortUrlListModel extends ShortUrlList{
  ShortUrlListModel({required List<ShortUrlModel> data}) : super(data: data);

  factory ShortUrlListModel.fromJson(Map<String, dynamic> json){
   return ShortUrlListModel(
       data:  List.from(json["urls"].map((element) => ShortUrlModel.fromJson(element)))
   );
  }


  @override
  Map<String, dynamic> toJson() => {
    "urls": List<Map<String, dynamic>>.from(data.map((element) => element.toJson()))
  };
}


class ShortUrlModel extends ShortUrl{
  ShortUrlModel({
    required bool ok,
    ShortUrlResultModel? result,
    int? errorCode,
    String? error
  }) : super(ok: ok, result: result, errorCode: errorCode, error: error);

  factory ShortUrlModel.fromJson(Map<String, dynamic> json) {
    return ShortUrlModel(
      ok: json['ok'],
      result: json['result'] != null ? ShortUrlResultModel.fromJson(json['result']) : null,
      error: json['error'],
      errorCode: json['error_code'],

    );
  }

  @override
  Map<String, dynamic> toJson() => {
      "ok": ok,
      "result": result != null ? result!.toJson() : null
  };
}

class ShortUrlResultModel extends ShortUrlResult{
  const ShortUrlResultModel({
    required String code,
    required String shortLink,
    required String fullShortLink,
    required String shortLink2,
    required String fullShortLink2,
    required String shortLink3,
    required String fullShortLink3,
    required String shareLink,
    required String fullShareLink,
    required String originalLink,
  }) : super(
      code: code,
      shortLink: shortLink,
      fullShortLink: fullShortLink,
      shortLink2: shortLink2,
      fullShortLink2: fullShortLink2,
      shortLink3: shortLink3,
      fullShortLink3: fullShortLink3,
      shareLink: shareLink,
      fullShareLink: fullShareLink,
      originalLink: originalLink
  );

  factory ShortUrlResultModel.fromJson(Map<String, dynamic> json){
      return ShortUrlResultModel(
          code: json['code'],
          shortLink: json['short_link'],
          fullShortLink: json['full_short_link'],
          shortLink2: json['short_link2'],
          fullShortLink2: json['full_short_link2'],
          shortLink3: json['short_link3'],
          fullShortLink3: json['full_short_link3'],
          shareLink: json['share_link'],
          fullShareLink: json['full_share_link'],
          originalLink: json['original_link']
      );
  }

  @override
  Map<String, dynamic> toJson() => {
    "code": code,
    "short_link": shortLink,
    "full_short_link": fullShortLink,
    "short_link2": shortLink2,
    "full_short_link2": fullShortLink2,
    "short_link3": shortLink3,
    "full_short_link3": fullShortLink3,
    "share_link": shareLink,
    "full_share_link": fullShareLink,
    "original_link": originalLink
  };
}