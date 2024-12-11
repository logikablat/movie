class Movie {
  final String title;
  final String year;
  final String imdbId;
  final String type;
  final String poster;
  String? rating; // Сделали поле изменяемым
  final String? description;
  final String? genres;

  Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
    this.rating,
    this.description,
    this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] as String,
      year: json['Year'] as String,
      imdbId: json['imdbID'] as String,
      type: json['Type'] as String,
      poster: json['Poster'] as String,
      rating: json['imdbRating'] as String?,
      description: json['Plot'] as String?,
      genres: json['Genre'] as String?,
    );
  }
}