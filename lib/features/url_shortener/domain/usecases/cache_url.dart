import 'package:dartz/dartz.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/core/usecases/usecases.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/repositories/short_url_repository.dart';

class CacheUrlUseCase implements UseCase<ShortUrlList?, CacheUrlParams>{
  ShortUrlRepository repository;

  CacheUrlUseCase(this.repository);

  @override
  Future<Either<Failure, ShortUrlList?>> call(CacheUrlParams params) async{
    final result = await repository.cacheUrl(params.list);
    return const Right(null);
  }
}

class CacheUrlParams {
  final ShortUrlList list;
  CacheUrlParams({required this.list});
}