import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class ViewModelVideoPlayer extends ChangeNotifier {
  List<VideoPlayerController>? _videoPlayerController;

  List<VideoPlayerController> get videoPlayerController =>
      _videoPlayerController!;

  set videoPlayerController(List<VideoPlayerController> value) {
    _videoPlayerController = value;
    notifyListeners();
  }
}

final homeProvier = ChangeNotifierProvider<ViewModelVideoPlayer>((ref) {
  return ViewModelVideoPlayer();
});
