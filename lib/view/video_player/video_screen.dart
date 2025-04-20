import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insta_video_player/view_model/video_player/view_model_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<VideoScreen> {
  @override
  void didChangeDependencies() {
    ref.read(homeProvier.notifier).videoPlayerController = [
      VideoPlayerController.asset("assets/videos/Instagram1.mp4")..initialize(),
      VideoPlayerController.asset("assets/videos/Instagram2.mp4")..initialize(),
      VideoPlayerController.asset("assets/videos/Instagram3.mp4")..initialize(),
      VideoPlayerController.asset("assets/videos/Instagram4.mp4")..initialize(),
      VideoPlayerController.asset("assets/videos/Instagram5.mp4")..initialize(),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final homeProvider =
                    ref.watch<ViewModelVideoPlayer>(homeProvier);
                return PageView.builder(
                  itemCount: homeProvider.videoPlayerController.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    homeProvider.videoPlayerController[index].play();
                    return Center(
                        child: homeProvider.videoPlayerController[index].value
                                .isInitialized
                            ? AspectRatio(
                                aspectRatio: homeProvider
                                    .videoPlayerController[index]
                                    .value
                                    .aspectRatio,
                                child: VideoPlayer(
                                    homeProvider.videoPlayerController[index]),
                              )
                            : Container());
                  },
                );
              },
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
