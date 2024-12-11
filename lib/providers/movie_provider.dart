import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  Dio _dio = Dio();

  void setDio(Dio dio) {
    _dio = dio;
  }

  List<Movie> movies = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> searchMovies(String query) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://www.omdbapi.com/',
        queryParameters: {
          's': query,
          'apikey': '85585f2f',
        },
      );

      if (response.data['Response'] == 'True') {
        movies = (response.data['Search'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();

        // Попытка получить рейтинг для каждого фильма
        for (var movie in movies) {
          final details = await fetchMovieDetails(movie.imdbId);
          if (details != null) {
            movie.rating = details.rating; // Обновляем рейтинг в списке фильмов
          }
        }
      } else {
        errorMessage = response.data['Error'] ?? 'No movies found.';
        movies = [];
      }
    } catch (error) {
      errorMessage = 'An error occurred. Please try again.';
      movies = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Movie?> fetchMovieDetails(String imdbId) async {
    try {
      final response = await _dio.get(
        'https://www.omdbapi.com/',
        queryParameters: {
          'i': imdbId,
          'apikey': '85585f2f',
        },
      );

      if (response.data['Response'] == 'True') {
        return Movie.fromJson(response.data);
      } else {
        errorMessage = response.data['Error'] ?? 'No details found.';
      }
    } catch (error) {
      errorMessage = 'An error occurred while fetching details.';
    }
    return null;
  }
}
