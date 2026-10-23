import 'package:youtube_explode_dart/youtube_explode_dart.dart';

MuxedStreamInfo? selectMuxedStreamForPlayback(
  Iterable<MuxedStreamInfo> streams,
) {
  final eligibleStreams = streams
      .where(
        (stream) =>
            stream.videoQuality != VideoQuality.unknown &&
            stream.videoQuality.index <= VideoQuality.high1080.index,
      )
      .toList();

  if (eligibleStreams.isEmpty) return null;

  final preferredQuality = eligibleStreams
      .reduce(
        (best, stream) =>
            stream.videoQuality.index > best.videoQuality.index ? stream : best,
      )
      .videoQuality;

  return eligibleStreams
      .where((stream) => stream.videoQuality == preferredQuality)
      .withHighestBitrate();
}
