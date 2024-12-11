import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/star_rating.dart';
import '../generated/l10n.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  final Function onToggleTheme;
  final Function(Locale) onChangeLocale;

  const MovieListScreen({
    Key? key,
    required this.onToggleTheme,
    required this.onChangeLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final movies = movieProvider.movies;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => onToggleTheme(),
          ),
          PopupMenuButton<Locale>(
            onSelected: (locale) => onChangeLocale(locale),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: const Text('English'),
              ),
              PopupMenuItem(
                value: const Locale('ru'),
                child: const Text('Русский'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: S.of(context).searchHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (query) {
                movieProvider.searchMovies(query);
              },
            ),
          ),
          if (movieProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (movieProvider.errorMessage.isNotEmpty)
            Center(child: Text(movieProvider.errorMessage))
          else
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final rating = double.tryParse(movie.rating ?? '0') ?? 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: Image.network(
                        movie.poster,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(movie.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${S.of(context).year}: ${movie.year}'),
                          const SizedBox(height: 4.0),
                          if (rating > 0)
                            Row(
                              children: [
                                StarRating(rating: double.parse(movie.rating!) / 2), // Рейтинг из IMDb
                                const SizedBox(width: 8),
                                Text('${rating.toStringAsFixed(1)}/10'),
                              ],
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              imdbId: movie.imdbId ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}