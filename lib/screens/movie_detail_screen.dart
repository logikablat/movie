import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/star_rating.dart';
import '../generated/l10n.dart';

class MovieDetailScreen extends StatefulWidget {
  final String imdbId;

  const MovieDetailScreen({Key? key, required this.imdbId}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    final fetchedMovie = await provider.fetchMovieDetails(widget.imdbId);
    setState(() {
      movie = fetchedMovie;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).loading),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
        ),
        body: Center(
          child: Text(S.of(context).noMoviesFound),
        ),
      );
    }

    final rating = double.tryParse(movie!.rating ?? '0') ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie!.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                movie!.poster,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 100),
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              movie!.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${S.of(context).year}: ${movie!.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            if (movie!.description != null)
              Text(
                movie!.description!,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 16.0),

            // Добавляем текстовый рейтинг
            Text(
              'Рейтинг: ${rating.toStringAsFixed(1)}/10',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8.0),

          ],
        ),
      ),
    );
  }
}
