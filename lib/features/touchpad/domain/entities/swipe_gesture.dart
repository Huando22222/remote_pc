// domain/entities/swipe_gesture.dart
class SwipeGesture {
  final int fingers; // 2, 3, 4
  final String direction; // up, down, left, right

  const SwipeGesture({required this.fingers, required this.direction});
}
