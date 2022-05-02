import 'package:equatable/equatable.dart';

abstract class ShortUrlList extends Equatable{
  List<ShortUrl> data;

  ShortUrlList({required this.data});

  @override
  List<Object?> get props => [data];

  Map<String, dynamic> toJson();
}

abstract class ShortUrl extends Equatable{
  final bool ok;
  final ShortUrlResult? result;
  int? errorCode;
  String? error;
  ShortUrl({required this.ok, this.result, this.error, this.errorCode});

  @override
  List<Object?> get props => [ok, result];

  Map<String, dynamic> toJson();
}

abstract class ShortUrlResult extends Equatable{
  final String code;
  final String shortLink;
  final String fullShortLink;
  final String shortLink2;
  final String fullShortLink2;
  final String shortLink3;
  final String fullShortLink3;
  final String shareLink;
  final String fullShareLink;
  final String originalLink;

  const ShortUrlResult({
    required this.code,
    required this.shortLink,
    required this.fullShortLink,
    required this.shortLink2,
    required this.fullShortLink2,
    required this.shortLink3,
    required this.fullShortLink3,
    required this.shareLink,
    required this.fullShareLink,
    required this.originalLink
  });

  @override
  List<Object?> get props => [
    code,
    shortLink,
    fullShortLink,
    shortLink2,
    fullShortLink2,
    shortLink3,
    fullShortLink3,
    shareLink,
    fullShareLink,
    originalLink
  ];

  Map<String, dynamic> toJson();
}

