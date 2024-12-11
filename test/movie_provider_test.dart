import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/providers/movie_provider.dart';
import 'package:dio/dio.dart';

import 'movie_provider_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late MovieProvider movieProvider;

  setUp(() {
    mockDio = MockDio();
    movieProvider = MovieProvider();
    movieProvider.setDio(mockDio); // Используем сеттер
  });

  test('searchMovies successfully fetches movies', () async {
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              data: {
                'Response': 'True',
                'Search': [
                  {
                    'Title': 'Inception',
                    'Year': '2010',
                    'Poster': 'https://example.com/inception.jpg',
                    'imdbID': 'tt1375666',
                  },
                ],
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    await movieProvider.searchMovies('Inception');

    expect(movieProvider.movies.length, 1);
    expect(movieProvider.movies.first.title, 'Inception');
  });
}
