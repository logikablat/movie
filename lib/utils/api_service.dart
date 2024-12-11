import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.omdbapi.com/';
  static const String apiKey = '85585f2f'; // Замените своим ключом


  // Метод для получения списка фильмов по запросу
  Future<Map<String, dynamic>> fetchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/?apikey=$apiKey&s=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Метод для получения полной информации о фильме
  Future<Map<String, dynamic>> fetchMovieDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/?apikey=$apiKey&i=$id&plot=full'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}