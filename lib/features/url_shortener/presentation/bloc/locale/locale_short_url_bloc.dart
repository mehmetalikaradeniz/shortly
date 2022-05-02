import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortly/core/check_internet/check_network.dart';
import 'package:shortly/core/usecases/usecases.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_local_data_source.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_remote_data_source.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';
import 'package:shortly/features/url_shortener/data/repositories/short_url_repository_impl.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/cache_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url_list.dart';


part 'locale_state.dart';
part 'locale_event.dart';


class LocaleShortUrlBloc extends Bloc<ShortUrlEvent, ShortUrlState>{
  late ShortUrlRepositoryImpl repositoryImpl;
  late ShortUrlRemoteDataSourceImpl remoteDataSource;
  late ShortUrlLocalDataSourceImpl localDataSource;
  late CheckNetworkImpl checkNetwork;
  late SharedPreferences sharedPreferences;
  late GetShortUrl getShortUrl;
  late GetShortUrlList getShortUrlList;
  late CacheUrlUseCase cacheUrl;
  late ShortUrlList shortUrlList;

  LocaleShortUrlBloc(ShortUrlState initialState) : super(Idle()){
    on<GetWarm>(_onGetWarm);
    on<GetShortUrlListFromCache>(_onGetShortUrlListFromCache);
    on<CacheUrl>(_onCacheUrl);
    on<RemoveUrlFromCache>(_onRemoveUrlFromCache);
  }

  _onGetWarm(GetWarm event, Emitter<ShortUrlState> emit) async{
    emit(WarmingUp());
    sharedPreferences = await SharedPreferences.getInstance();
    remoteDataSource = ShortUrlRemoteDataSourceImpl(client: http.Client());
    localDataSource = ShortUrlLocalDataSourceImpl(
        sharedPreferences: sharedPreferences
    );
    checkNetwork = CheckNetworkImpl();
    repositoryImpl = ShortUrlRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        checkNetworkImpl: checkNetwork
    );
    getShortUrl = GetShortUrl(repositoryImpl);
    getShortUrlList = GetShortUrlList(repositoryImpl);
    cacheUrl = CacheUrlUseCase(repositoryImpl);
    shortUrlList = ShortUrlListModel(data: []);
    Future.delayed(const Duration(milliseconds: 1200), () => add(GetShortUrlListFromCache()));
  }
  _onGetShortUrlListFromCache(GetShortUrlListFromCache event, Emitter<ShortUrlState> emit) async{
    emit(UrlListRequesting());
    final result = await getShortUrlList(NoParams());
    emit(result.fold(
            (l) => UrlListFailure(failure: l),
            (r) {
              if(r == null || r.data.isEmpty){
                shortUrlList.data = [];
                return UrlListEmpty();
              }
              else{
                shortUrlList = r;
                return UrlListLoaded(shortUrlList: r);
              }
        }
    ));
  }

  _onCacheUrl(CacheUrl event, Emitter<ShortUrlState> emit) async{
    emit(UrlCacheStarted());
    shortUrlList.data.add(event.url);
    await cacheUrl(CacheUrlParams(list: shortUrlList));
    emit(AddedNewUrl(shortUrlList: shortUrlList));
  }
  _onRemoveUrlFromCache(RemoveUrlFromCache event, Emitter<ShortUrlState> emit) async{
    emit(UrlCacheStarted());
    shortUrlList.data.remove(event.url);
    await cacheUrl(CacheUrlParams(list: shortUrlList));
    emit(shortUrlList.data.isEmpty ? UrlListEmpty() : UrlRemoved(shortUrlList: shortUrlList));
  }

  ShortUrlState get initialState => Idle();
}
