part of 'locale_short_url_bloc.dart';

abstract class ShortUrlState extends Equatable {
  @override
  List<Object> get props => [];
}

class Idle extends ShortUrlState{}
class WarmingUp extends ShortUrlState{}

class UrlListRequesting extends ShortUrlState{}
class UrlListEmpty extends ShortUrlState{}
class UrlCacheStarted extends ShortUrlState{}
class UrlListLoaded extends ShortUrlState{
  ShortUrlList? shortUrlList;

  UrlListLoaded({required this.shortUrlList});
}
class AddedNewUrl extends ShortUrlState{
  ShortUrlList? shortUrlList;

  AddedNewUrl({required this.shortUrlList});
}
class UrlRemoved extends ShortUrlState{
  ShortUrlList? shortUrlList;

  UrlRemoved({required this.shortUrlList});
}
class UrlListFailure extends ShortUrlState{
  final dynamic failure;
  UrlListFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
