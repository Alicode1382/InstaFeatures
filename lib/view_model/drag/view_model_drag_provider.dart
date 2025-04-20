import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewModelDragProvider extends ChangeNotifier {
  final List<Offset> _positions = [];
  final double itemSpacing = 60;

  int? _draggingIndex;
  Offset? _draggingPosition;

  List<Offset> get positions => _positions;
  int? get draggingIndex => _draggingIndex;
  Offset? get draggingPosition => _draggingPosition;

  void createItem() {
    final newOffset = Offset(150, _positions.length * itemSpacing + 100);
    _positions.add(newOffset);
    notifyListeners();
  }

  void startDragging(int index) {
    _draggingIndex = index;
    _draggingPosition = _positions[index];
    notifyListeners();
  }

  void updateItemPosition(int index, Offset delta) {
    if (index < 0 || index >= _positions.length) return;
    _positions[index] += delta;
    _draggingPosition = _positions[index];
    notifyListeners();
  }

  void stopDragging() {
    _draggingIndex = null;
    _draggingPosition = null;
    notifyListeners();
  }

  void deleteItem(int index) {
    _positions.removeAt(index);
    _draggingIndex = null;
    _draggingPosition = null;
    notifyListeners();
  }
}

final storyProvider = ChangeNotifierProvider((ref) => ViewModelDragProvider());
