import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shortly/features/url_shortener/data/models/short_url_model.dart';
import 'package:shortly/features/url_shortener/domain/repositories/short_url_repository.dart';
import 'package:shortly/features/url_shortener/domain/usecases/get_short_url.dart';
import 'get_short_url_test.mocks.dart';


@GenerateMocks([], customMocks: [
  MockSpec<ShortUrlRepository>(as: #MockShortUrlRepository),
])
void main(){
  const url = "https://api.shrtco.de/v2/shorten?url=example.org/very/long/link.html";
  late MockShortUrlRepository mockShortUrlRepository;
  late GetShortUrl useCase;
  late ShortUrlResultModel mockShortUrlResult;
  late ShortUrlModel mockShortUrl;
  setUp((){
    mockShortUrlResult = const ShortUrlResultModel(
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
    );
    mockShortUrl = ShortUrlModel(
        ok: true,
        result: mockShortUrlResult
    );
    mockShortUrlRepository = MockShortUrlRepository();
    useCase = GetShortUrl(mockShortUrlRepository);
  });



  test(
    'should get short url from the repository with url param',
      () async {

        when(mockShortUrlRepository.shortenUrl(url))
            .thenAnswer((_) async => Right(mockShortUrl));

        final result = await useCase(Params(url: url));

        expect(result, equals(Right(mockShortUrl)));
        verify(mockShortUrlRepository.shortenUrl(url));
        verifyNoMoreInteractions(mockShortUrlRepository);

      }
  );
  
}