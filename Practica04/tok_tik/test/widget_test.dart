import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tok_tik/config/theme/app_theme.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/widgets/shared/video_buttons.dart';

void main() {
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

    final updated = video.copyWith(
      likes: 11,
      isLiked: true,
      views: 101,
    );

    expect(updated.likes, 11);
    expect(updated.isLiked, true);
    expect(updated.views, 101);
  });

  testWidgets('VideoButtons renders Heart, Views, Share and Mute buttons', (tester) async {
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
        home: Scaffold(
          body: VideoButtons(
            video: video,
            isMuted: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.remove_red_eye_outlined), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
  });

  test('ThemeProvider cycles through Normal, Halloween, and Christmas', () async {
    final themeProvider = ThemeProvider();
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
    expect(themeProvider.season, AppSeason.normal);
  });
}
