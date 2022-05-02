import 'package:dartz/dartz.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/core/usecases/usecases.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/repositories/short_url_repository.dart';

class GetShortUrlList implements UseCase<ShortUrlList?, NoParams>{
  ShortUrlRepository repository;

  GetShortUrlList(this.repository);

  @override
  Future<Either<Failure, ShortUrlList?>> call(NoParams params) async{
    return await repository.getListFromCache();
  }
}