import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('splash screen keeps audio audible for four seconds by default', () {
    expect(const SplashScreen().duration, const Duration(seconds: 4));
  });

  testWidgets('plays the active theme intro once and replaces the splash', (
    tester,
  ) async {
    var playCount = 0;
    String? playedAsset;
    final themeProvider = ThemeProvider(playSound: (_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: MaterialApp(
          home: SplashScreen(
            duration: const Duration(milliseconds: 3500),
            playIntroSound: (asset) async {
              playCount++;
              playedAsset = asset;
            },
            homeBuilder: (_) => const Scaffold(body: Text('home screen')),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(playCount, 1);
    expect(playedAsset, themeProvider.soundAsset);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    themeProvider.notifyListeners();
    await tester.pump();
    expect(playCount, 1);

    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('home screen'), findsOneWidget);
    themeProvider.dispose();
  });
}
