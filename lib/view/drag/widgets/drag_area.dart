import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insta_video_player/view_model/drag/view_model_drag_provider.dart';

class StatefulDragArea extends ConsumerWidget {
  const StatefulDragArea({super.key});

  bool isNearTrash(Offset? itemPosition, Offset trashCenter,
      {double threshold = 130}) {
    if (itemPosition == null) return false;
    return (itemPosition - trashCenter).distance < threshold;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final story = ref.watch(storyProvider);
    final notifier = ref.read(storyProvider.notifier);
    final size = MediaQuery.of(context).size;

    final trashCenter = Offset(size.width / 2, size.height - 100);
    final isNear = isNearTrash(story.draggingPosition, trashCenter);

    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.grey[100])),
        for (int index = 0; index < story.positions.length; index++)
          Positioned(
            left: story.positions[index].dx,
            top: story.positions[index].dy,
            child: GestureDetector(
              onPanStart: (_) => notifier.startDragging(index),
              onPanUpdate: (details) {
                notifier.updateItemPosition(index, details.delta);
              },
              onPanEnd: (_) {
                if (isNearTrash(story.positions[index], trashCenter)) {
                  notifier.deleteItem(index);
                } else {
                  notifier.stopDragging();
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 40,
          left: size.width / 2 - 65,
          child: isNear
              ? Image.asset(
                  'assets/images/trush.png',
                  width: 130,
                  height: 130,
                  color: Colors.red,
                )
              : Icon(
                  Icons.delete,
                  color: isNear ? Colors.red : Colors.black,
                  size: 130,
                ),
        ),
      ],
    );
  }
}
