import 'package:dartz/dartz.dart';
import 'package:shortly/core/check_internet/check_network.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_local_data_source.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_remote_data_source.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/repositories/short_url_repository.dart';


class ShortUrlRepositoryImpl implements ShortUrlRepository{
  final ShortUrlLocalDataSource localDataSource;
  final ShortUrlRemoteDataSource remoteDataSource;
  final CheckNetworkImpl checkNetworkImpl;
  const ShortUrlRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.checkNetworkImpl});

  @override
  Future<Either<Failure, ShortUrl>> shortenUrl(String url) async{
    if(await checkNetworkImpl.hasNetwork()){
      final result = await remoteDataSource.getShortUrl(url);
      if(result.ok){
        return Right(result);
      }
      else {
        return Left(RequestFailure(message: result.error != null ? result.error! : "Unknown Error"));
      }
    }
    else {
      return Left(ConnectionFailure());
    }

  }

  @override
  Future<Either<Failure, ShortUrlList?>> getListFromCache() async{
    final result = localDataSource.getShortUrlList();
    return Right(result);
  }

  @override
  Future<Either<Failure, ShortUrlList?>> cacheUrl(ShortUrlList shortUrlList) async{
    localDataSource.cacheShortUrl(shortUrlList);
    return await Future.delayed(Duration.zero, () => const Right(null),);
  }
}