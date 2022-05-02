part of 'remote_short_url_bloc.dart';

abstract class RemoteShortUrlBlocShortUrlState extends Equatable {
  @override
  List<Object> get props => [];
}

class RemoteShortUrlBlocIdle extends RemoteShortUrlBlocShortUrlState{}
class RemoteShortUrlBlocWarmingUp extends RemoteShortUrlBlocShortUrlState{}
class RemoteShortUrlBlocReady extends RemoteShortUrlBlocShortUrlState{}
class RemoteShortUrlBlocShortUrlRequesting extends RemoteShortUrlBlocShortUrlState{}
class RemoteShortUrlBlocShortUrlRequested extends RemoteShortUrlBlocShortUrlState{
  ShortUrl shortUrl;

  RemoteShortUrlBlocShortUrlRequested({required this.shortUrl});
  List<Object> get props => [shortUrl];
}
class RemoteShortUrlBlocShortUrlRequestFailure extends RemoteShortUrlBlocShortUrlState{
  final Failure failure;
  RemoteShortUrlBlocShortUrlRequestFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
