import 'package:dartz/dartz.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';

abstract class ShortUrlRepository{
  Future<Either<Failure, ShortUrl>> shortenUrl(String url);
  Future<Either<Failure, ShortUrlList?>> getListFromCache();
  Future<void> cacheUrl(ShortUrlList shortUrlList);
}