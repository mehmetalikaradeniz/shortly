part of 'remote_short_url_bloc.dart';

abstract class ShortUrlEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForceRemoteBlocToBeIdle extends ShortUrlEvent{}
class RemoteShortUrlBlocShortUrlGetWarm extends ShortUrlEvent{}
class RequestNewShortUrlFromRemote extends ShortUrlEvent {
  final String url;

  RequestNewShortUrlFromRemote(this.url);

  @override
  List<Object> get props => [url];
}