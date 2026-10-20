import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/discover_provider.dart';
import 'package:tok_tik/presentation/providers/for_you_provider.dart';
import 'package:tok_tik/presentation/providers/near_you_provider.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Aviso: No se pudo cargar el archivo .env: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ForYouProvider()..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider()..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => NearYouProvider()..loadNextPage(),
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
      home: const HomeScreen(),
    );
  }
}
