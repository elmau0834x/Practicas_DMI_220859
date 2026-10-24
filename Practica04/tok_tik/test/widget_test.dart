import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tok_tik/config/theme/app_theme.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/expandable_caption.dart';
import 'package:tok_tik/presentation/widgets/shared/video_buttons.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const iconChannel = MethodChannel('com.toktik.app/icon');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(iconChannel, (_) async => null);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('VideoPost entity supports id, isLiked and copyWith', () {
    final video = VideoPost(
      id: 'test_1',
      caption: 'Test video',
      videoUrl: 'https://example.com/video.mp4',
      likes: 10,
      views: 100,
      isLiked: false,
    );

    expect(video.id, 'test_1');
    expect(video.isLiked, false);

    final updated = video.copyWith(likes: 11, isLiked: true, views: 101);

    expect(updated.likes, 11);
    expect(updated.isLiked, true);
    expect(updated.views, 101);
  });

  testWidgets('VideoButtons renders Heart, Views, Share and Mute buttons', (
    tester,
  ) async {
    final video = VideoPost(
      id: 'test_button',
      caption: 'Button test',
      videoUrl: 'https://example.com/video.mp4',
      likes: 50,
      views: 200,
      isLiked: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: VideoButtons(video: video, isMuted: true)),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.remove_red_eye_outlined), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
  });

  testWidgets('ExpandableCaption expands long text into a scrollable area', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpandableCaption(
            caption:
                'This is a deliberately long caption that must exceed two '
                'lines so the expandable control is displayed and the full '
                'description can be read by scrolling inside the caption.',
          ),
        ),
      ),
    );

    expect(find.text('(... más)'), findsOneWidget);
    await tester.tap(find.text('(... más)'));
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('(... menos)'), findsOneWidget);
  });

  test(
    'ThemeProvider cycles through all seasonal themes and persists them',
    () async {
      final themeProvider = ThemeProvider(playSound: (_) async {});
      await themeProvider.setSeason(AppSeason.normal);

      expect(themeProvider.season, AppSeason.normal);
      expect(themeProvider.seasonName, 'Normal');

      await themeProvider.cycleTheme();
      expect(themeProvider.season, AppSeason.halloween);
      expect(themeProvider.seasonName, 'Halloween');

      await themeProvider.cycleTheme();
      expect(themeProvider.season, AppSeason.christmas);
      expect(themeProvider.seasonName, 'Navidad');

      await themeProvider.cycleTheme();
      expect(themeProvider.season, AppSeason.valentine);
      expect(themeProvider.seasonName, 'San Valentín');
      expect(themeProvider.soundAsset, 'audios/valentine_sound.wav');

      await themeProvider.cycleTheme();
      expect(themeProvider.season, AppSeason.normal);

      final restoredProvider = await ThemeProvider.load(
        playSound: (_) async {},
      );
      expect(restoredProvider.season, AppSeason.normal);
    },
  );

  test(
    'ThemeProvider restores a cached season before the calendar season',
    () async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('app_season', AppSeason.halloween.name);

      final themeProvider = await ThemeProvider.load(playSound: (_) async {});

      expect(themeProvider.season, AppSeason.halloween);
      expect(themeProvider.soundAsset, 'audios/halloween_sound.mp3');
      expect(
        themeProvider.currentTheme.textTheme.bodyMedium?.fontFamily,
        'monospace',
      );
    },
  );

  test('theme sound only plays after an explicit season change', () async {
    var playCount = 0;
    final themeProvider = ThemeProvider(
      playSound: (_) async {
        playCount++;
      },
    );

    expect(playCount, 0);
    await themeProvider.setSeason(themeProvider.season);
    themeProvider.notifyListeners();
    expect(playCount, 0);

    final nextSeason = AppSeason.values.firstWhere(
      (season) => season != themeProvider.season,
    );
    await themeProvider.setSeason(nextSeason);
    expect(playCount, 1);
    themeProvider.dispose();
  });

  test('VideoPost asserts a non-empty caption and non-negative counters', () {
    expect(
      () => VideoPost(caption: '  ', videoUrl: 'video.mp4'),
      throwsAssertionError,
    );
    expect(
      () => VideoPost(caption: 'caption', videoUrl: 'video.mp4', likes: -1),
      throwsAssertionError,
    );
    expect(
      () => VideoPost(caption: 'caption', videoUrl: 'video.mp4', views: -1),
      throwsAssertionError,
    );
  });
}
