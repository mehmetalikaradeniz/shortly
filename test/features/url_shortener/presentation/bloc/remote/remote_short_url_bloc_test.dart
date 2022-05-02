import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url.dart';
import 'package:shortly/features/url_shortener/presentation/bloc/remote/remote_short_url_bloc.dart';

class MockGetShortUrl extends Mock implements GetShortUrl{}
main(){
  late RemoteShortUrlBloc bloc;
  late MockGetShortUrl mockGetShortUrl;
  String successInput = "example.org/very/long/link.html";
  String failedInput = "mmmmm";
  String missingParamInput = "";
  ShortUrl shortUrl = ShortUrlModel(
      ok: true,
      result: const ShortUrlResultModel(
          code: "mQpaT",
          shortLink: "shrtco.de/mQpaT",
          fullShortLink: "https://shrtco.de/mQpaT",
          shortLink2: "9qr.de/mQpaT",
          fullShortLink2: "https://9qr.de/mQpaT",
          shortLink3: "shiny.link/mQpaT",
          fullShortLink3: "https://shiny.link/mQpaT",
          shareLink: "shrtco.de/share/mQpaT",
          fullShareLink: "https://shrtco.de/share/mQpaT",
          originalLink: "http://example.org/very/long/link.html"
      )
  );
  ShortUrl badRequestResponse = ShortUrlModel(
      ok: false,
      errorCode: 2,
      error: "This is not a valid URL, for more infos see shrtco.de/docs"
  );

  ShortUrl missingUrlParamResponse = ShortUrlModel(
      ok: false,
      errorCode: 1,
      error: "No url parameter set. Make a GET or POST request with a `url` parameter containing a URL you want to shorten. For more infos see shrtco.de/docs"
  );

  setUp((){
    mockGetShortUrl = MockGetShortUrl();
    bloc = RemoteShortUrlBloc(RemoteShortUrlBlocIdle());
  });

  test('initialState should be RemoteShortUrlBlocIdle', () {
    expect(bloc.initialState, equals(RemoteShortUrlBlocIdle()));
  });

  test("should emit Warming Up State", () async* {
    final expected = [
      RemoteShortUrlBlocWarmingUp(),
      RemoteShortUrlBlocReady(),
    ];
    expectLater(bloc.state, emitsInOrder(expected));
    bloc.add(RemoteShortUrlBlocShortUrlGetWarm());
  });

  group("get short url from remote", (){
    test("should return RemoteShortUrlBlocShortUrlRequested when successfully request", () async* {
      when(mockGetShortUrl(Params(url: successInput)))
          .thenAnswer((_) async => Right(shortUrl));
      final expected = [
        RemoteShortUrlBlocShortUrlRequesting(),
        RemoteShortUrlBlocShortUrlRequested(shortUrl: shortUrl),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(RequestNewShortUrlFromRemote(successInput));
    });
    test("should return RemoteShortUrlBlocShortUrlRequestFailure when input is wrong", () async* {
      when(mockGetShortUrl(Params(url: failedInput)))
          .thenAnswer((_) async => Left(RequestFailure(message: badRequestResponse.error!)));
      final expected = [
        RemoteShortUrlBlocShortUrlRequesting(),
        RemoteShortUrlBlocShortUrlRequestFailure(failure: RequestFailure(message: badRequestResponse.error!)),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(RequestNewShortUrlFromRemote(failedInput));
    });
    test("should return RemoteShortUrlBlocShortUrlRequestFailure when missing input param", () async* {
      when(mockGetShortUrl(Params(url: missingParamInput)))
          .thenAnswer((_) async => Left(RequestFailure(message: missingUrlParamResponse.error!)));
      final expected = [
        RemoteShortUrlBlocShortUrlRequesting(),
        RemoteShortUrlBlocShortUrlRequestFailure(failure: RequestFailure(message: missingUrlParamResponse.error!)),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.add(RequestNewShortUrlFromRemote(missingParamInput));
    });
  });

  test("should emit RemoteShortUrlBlocIdle", () async* {
    final expected = [
      RemoteShortUrlBlocIdle(),
    ];
    expectLater(bloc.state, emitsInOrder(expected));
    bloc.add(ForceRemoteBlocToBeIdle());
  });
}