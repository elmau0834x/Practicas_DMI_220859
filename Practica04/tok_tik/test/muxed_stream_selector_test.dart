import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show MediaType;
import 'package:tok_tik/infrastructure/datasources/muxed_stream_selector.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  group('selectMuxedStreamForPlayback', () {
    test('prefers 1080p over 720p and excludes higher resolutions', () {
      final streams = [
        _stream(VideoQuality.high720, 10_000_000),
        _stream(VideoQuality.high1080, 2_000_000),
        _stream(VideoQuality.high2160, 20_000_000),
      ];

      final selected = selectMuxedStreamForPlayback(streams);

      expect(selected, same(streams[1]));
    });

    test('returns null when only resolutions above 1080p are available', () {
      final selected = selectMuxedStreamForPlayback([
        _stream(VideoQuality.high2160, 20_000_000),
      ]);

      expect(selected, isNull);
    });

    test('falls back to the highest available quality below 1080p', () {
      final streams = [
        _stream(VideoQuality.medium480, 4_000_000),
        _stream(VideoQuality.high720, 2_000_000),
      ];

      final selected = selectMuxedStreamForPlayback(streams);

      expect(selected, same(streams[1]));
    });
  });
}

MuxedStreamInfo _stream(VideoQuality quality, int bitrate) {
  final height = switch (quality) {
    VideoQuality.low144 => 144,
    VideoQuality.low240 => 240,
    VideoQuality.medium360 => 360,
    VideoQuality.medium480 => 480,
    VideoQuality.high720 => 720,
    VideoQuality.high1080 => 1080,
    VideoQuality.high1440 => 1440,
    VideoQuality.high2160 => 2160,
    VideoQuality.high2880 => 2880,
    VideoQuality.high3072 => 3072,
    VideoQuality.high4320 => 4320,
    VideoQuality.unknown => 0,
  };
  final qualityLabel = height == 0 ? 'Unknown' : '${height}p';

  return MuxedStreamInfo(
    VideoId('abcdefghijk'),
    18,
    Uri.parse('https://example.com/$qualityLabel'),
    StreamContainer.mp4,
    FileSize(1),
    Bitrate(bitrate),
    'aac',
    'avc1',
    qualityLabel,
    quality,
    VideoResolution(height * 9 ~/ 16, height),
    Framerate(30),
    MediaType('video', 'mp4'),
  );
}
