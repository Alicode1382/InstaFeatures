import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insta_video_player/screens/drag/widget/drag_area.dart';
import 'package:insta_video_player/screens/drag/provider/drag_provider.dart';

class DragScreen extends ConsumerWidget {
  const DragScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(storyProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notifier.createItem();
        },
        child: const Icon(Icons.add),
      ),
      body: const SafeArea(child: StatefulDragArea()),
    );
  }
}
