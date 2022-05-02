import 'package:dartz/dartz.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/core/usecases/usecases.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/repositories/short_url_repository.dart';

class GetShortUrl implements UseCase<ShortUrl, Params>{
  ShortUrlRepository repository;

  GetShortUrl(this.repository);

  @override
  Future<Either<Failure, ShortUrl>> call(Params params) async{
    return await repository.shortenUrl(params.url);
  }
}

class Params {
  final String url;
  Params({required this.url});
}