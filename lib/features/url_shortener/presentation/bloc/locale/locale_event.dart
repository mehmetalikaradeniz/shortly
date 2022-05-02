part of 'locale_short_url_bloc.dart';

abstract class ShortUrlEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetWarm extends ShortUrlEvent{}

class GetShortUrlListFromCache extends ShortUrlEvent {}
class CacheUrl extends ShortUrlEvent {
  ShortUrl url;

  CacheUrl({required this.url});

  @override
  List<Object> get props => [url];
}

class RemoveUrlFromCache extends ShortUrlEvent {
  ShortUrl url;

  RemoveUrlFromCache({required this.url});

  @override
  List<Object> get props => [url];
}
