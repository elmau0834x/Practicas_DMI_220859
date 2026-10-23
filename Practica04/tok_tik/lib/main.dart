import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/infrastructure/datasources/local_video_datasource_implementation.dart';
import 'package:tok_tik/infrastructure/datasources/movie_video_datasource.dart';
import 'package:tok_tik/infrastructure/datasources/pixabay_video_datasource.dart';
import 'package:tok_tik/infrastructure/datasources/youtube_video_datasource.dart';
import 'package:tok_tik/infrastructure/repositories/movie_video_repository_impl.dart';
import 'package:tok_tik/infrastructure/repositories/favorite_videos_repository_impl.dart';
import 'package:tok_tik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:tok_tik/presentation/providers/discover_provider.dart';
import 'package:tok_tik/presentation/providers/favorites_provider.dart';
import 'package:tok_tik/presentation/providers/for_you_provider.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/providers/video_source_provider.dart';
import 'package:tok_tik/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Aviso: No se pudo cargar el archivo .env: $e');
  }
  final themeProvider = await ThemeProvider.load();
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.themeProvider, super.key});

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    final favoritesRepository = FavoriteVideosRepositoryImpl();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(
          create: (_) => VideoSourceProvider(
            localRepository: VideoPostsRepositoryImpl(
              videosDatasource: LocalVideoDatasource(),
            ),
            youtubeRepository: VideoPostsRepositoryImpl(
              videosDatasource: YoutubeVideoDatasource(),
            ),
            pixabayRepository: VideoPostsRepositoryImpl(
              videosDatasource: PixabayVideoDatasource(),
            ),
            tmdbRepository: MovieVideoRepositoryImpl(
              datasource: MovieVideoDatasource(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) =>
              FavoritesProvider(repository: favoritesRepository)
                ..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => ForYouProvider(
            sourceProvider: context.read<VideoSourceProvider>(),
            favoritesRepository: favoritesRepository,
            onFavoritesChanged: context.read<FavoritesProvider>().loadNextPage,
          )..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => DiscoverProvider(
            sourceProvider: context.read<VideoSourceProvider>(),
            favoritesRepository: favoritesRepository,
            onFavoritesChanged: context.read<FavoritesProvider>().loadNextPage,
          )..loadNextPage(),
        ),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'TokTik',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const SplashScreen(),
    );
  }
}
