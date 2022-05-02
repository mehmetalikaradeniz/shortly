import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shortly/core/check_internet/check_network.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_local_data_source.dart';
import 'package:shortly/features/url_shortener/data/datasources/short_url_remote_data_source.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';
import 'package:shortly/features/url_shortener/data/repositories/short_url_repository_impl.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'short_url_repository_impl_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ShortUrlRemoteDataSource>(as: #MockShortUrlRemoteDataSource),
  MockSpec<ShortUrlLocalDataSource>(as: #MockShortUrlLocalDataSource),
  MockSpec<CheckNetworkImpl>(as: #MockCheckNetworkImpl),
])
main(){
  const url = "https://api.shrtco.de/v2/shorten?url=example.org/very/long/link.html";
  const badUrl = "https://api.shrtco.de/v2/shorten?url=mmmmm";
  const missingUrlParam = "https://api.shrtco.de/v2/shorten";

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

  ShortUrlList list = ShortUrlListModel(
      data: [
        shortUrl as ShortUrlModel,
        shortUrl as ShortUrlModel,
        shortUrl as ShortUrlModel
      ]
  );

  late ShortUrlRepositoryImpl shortUrlRepositoryImpl;
  late MockShortUrlLocalDataSource mockShortUrlLocalDataSource;
  late MockShortUrlRemoteDataSource mockShortUrlRemoteDataSource;
  late MockCheckNetworkImpl mockCheckNetworkImpl;
  setUp((){
    mockCheckNetworkImpl = MockCheckNetworkImpl();
    mockShortUrlLocalDataSource = MockShortUrlLocalDataSource();
    mockShortUrlRemoteDataSource = MockShortUrlRemoteDataSource();
    shortUrlRepositoryImpl = ShortUrlRepositoryImpl(
      remoteDataSource: mockShortUrlRemoteDataSource,
      localDataSource: mockShortUrlLocalDataSource,
      checkNetworkImpl: mockCheckNetworkImpl
    );
  });

  group('should get short url from api', (){
    test('is device online', () async {
      when(mockCheckNetworkImpl.hasNetwork())
          .thenAnswer((_) async => true);
      when(mockShortUrlRemoteDataSource.getShortUrl(url))
          .thenAnswer((_) async => shortUrl);
      final result = await shortUrlRepositoryImpl.shortenUrl(url);
      verify(mockShortUrlRemoteDataSource.getShortUrl(url));
      expect(result, equals(Right(shortUrl)));
    });
    test('is device offline', () async {
      when(mockCheckNetworkImpl.hasNetwork())
          .thenAnswer((_) async => false);
      when(mockShortUrlRemoteDataSource.getShortUrl(url))
          .thenAnswer((_) async => shortUrl);
      final result = await shortUrlRepositoryImpl.shortenUrl(url);
      verifyZeroInteractions(mockShortUrlRemoteDataSource);
      expect(result, equals(Left(ConnectionFailure())));
    });
  });

  group("should return failure response with wrong params", () {
    test("wrong url", () async{
      when(mockCheckNetworkImpl.hasNetwork())
          .thenAnswer((_) async => true);
      when(mockShortUrlRemoteDataSource.getShortUrl(badUrl))
          .thenAnswer((_) async => badRequestResponse as ShortUrlModel);
      final result = await shortUrlRepositoryImpl.shortenUrl(badUrl);
      verify(mockShortUrlRemoteDataSource.getShortUrl(badUrl));
      expect(result, equals(Left(RequestFailure(message: badRequestResponse.error!))));
    });
    test("missing url param", () async{
      when(mockCheckNetworkImpl.hasNetwork())
          .thenAnswer((_) async => true);
      when(mockShortUrlRemoteDataSource.getShortUrl(missingUrlParam))
          .thenAnswer((_) async => missingUrlParamResponse as ShortUrlModel);
      final result = await shortUrlRepositoryImpl.shortenUrl(missingUrlParam);
      verify(mockShortUrlRemoteDataSource.getShortUrl(missingUrlParam));
      expect(result, equals(Left(RequestFailure(message: missingUrlParamResponse.error!))));
    });
  });

  group("should request cached url list from shared preferences", (){
    test("should return cached url list", () async {
      when(mockShortUrlLocalDataSource.getShortUrlList())
          .thenAnswer((_) => list);

      final result = await shortUrlRepositoryImpl.getListFromCache();

      verify(mockShortUrlLocalDataSource.getShortUrlList());
      expect(result, equals(Right(list)));
    });
    test("should return null", () async {
      when(mockShortUrlLocalDataSource.getShortUrlList())
          .thenAnswer((_) => null);

      final result = await shortUrlRepositoryImpl.getListFromCache();

      verify(mockShortUrlLocalDataSource.getShortUrlList());
      expect(result, equals(Right(null)));
    });
  });

  test("should cache given url list to shared preferences", () async {
    when(mockShortUrlLocalDataSource.cacheShortUrl(list))
        .thenAnswer((_) async => null);
    final result = await shortUrlRepositoryImpl.cacheUrl(list);
    verify(mockShortUrlLocalDataSource.cacheShortUrl(list));
    expect(result, equals(const Right(null)));
  });




}