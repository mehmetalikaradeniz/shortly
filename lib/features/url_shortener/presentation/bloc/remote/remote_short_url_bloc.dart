import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortly/core/check_internet/check_network.dart';
import 'package:http/http.dart' as http;
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_local_data_source.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_remote_data_source.dart';
import 'package:shortly/features/url_shortener/data/repositories/short_url_repository_impl.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url_list.dart';


part 'remote_state.dart';
part 'remote_event.dart';


class RemoteShortUrlBloc extends Bloc<ShortUrlEvent, RemoteShortUrlBlocShortUrlState>{
  late ShortUrlRepositoryImpl repositoryImpl;
  late ShortUrlRemoteDataSourceImpl remoteDataSource;
  late ShortUrlLocalDataSourceImpl localDataSource;
  late CheckNetworkImpl checkNetwork;
  late SharedPreferences sharedPreferences;
  late GetShortUrl getShortUrl;
  late GetShortUrlList getShortUrlList;

  RemoteShortUrlBloc(RemoteShortUrlBlocShortUrlState initialState) : super(RemoteShortUrlBlocIdle()){
    on<RemoteShortUrlBlocShortUrlGetWarm>(_onGetWarm);
    on<RequestNewShortUrlFromRemote>(_onRequestNewShortUrlFromRemote);
    on<ForceRemoteBlocToBeIdle>(_onForceRemoteBlocToBeIdle);
  }

  _onGetWarm(RemoteShortUrlBlocShortUrlGetWarm event, Emitter<RemoteShortUrlBlocShortUrlState> emit) async{
    emit(RemoteShortUrlBlocWarmingUp());
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
    emit(RemoteShortUrlBlocReady());
  }
  _onRequestNewShortUrlFromRemote(RequestNewShortUrlFromRemote event, Emitter<RemoteShortUrlBlocShortUrlState> emit) async{
    emit(RemoteShortUrlBlocShortUrlRequesting());

    final result = await getShortUrl(Params(url: event.url));


    await Future.delayed(const Duration(milliseconds: 1200), () =>
    emit(result.fold(
            (l) => RemoteShortUrlBlocShortUrlRequestFailure(failure: l),
            (r) => RemoteShortUrlBlocShortUrlRequested(shortUrl: r)
    )));
  }
  _onForceRemoteBlocToBeIdle(ForceRemoteBlocToBeIdle event, Emitter<RemoteShortUrlBlocShortUrlState> emit){
    emit(RemoteShortUrlBlocIdle());
  }

  RemoteShortUrlBlocShortUrlState get initialState => RemoteShortUrlBlocIdle();
}
