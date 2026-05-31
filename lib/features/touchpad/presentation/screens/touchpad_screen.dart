import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/touchpad/domain/usecases/swipe_usecase.dart';
import 'package:pc_remote/features/touchpad/presentation/widgets/touchpad_widget.dart';
import '../../domain/usecases/move_mouse_usecase.dart';
import '../../domain/usecases/left_click_usecase.dart';
import '../../domain/usecases/right_click_usecase.dart';
import '../../domain/usecases/double_click_usecase.dart';
import '../../domain/usecases/mouse_down_usecase.dart';
import '../../domain/usecases/mouse_up_usecase.dart';
import '../../domain/usecases/scroll_usecase.dart';

class TouchpadScreen extends ConsumerStatefulWidget {
  const TouchpadScreen({super.key});

  @override
  ConsumerState<TouchpadScreen> createState() => _TouchpadScreenState();
}

class _TouchpadScreenState extends ConsumerState<TouchpadScreen> {
  @override
  Widget build(BuildContext context) {
    return TouchpadWidget(
      moveMouse: ref.read(moveMouseUseCaseProvider),
      leftClick: ref.read(leftClickUseCaseProvider),
      rightClick: ref.read(rightClickUseCaseProvider),
      doubleClick: ref.read(doubleClickUseCaseProvider),
      mouseDown: ref.read(mouseDownUseCaseProvider),
      mouseUp: ref.read(mouseUpUseCaseProvider),
      scroll: ref.read(scrollUseCaseProvider),
      swipe: ref.read(swipeUseCaseProvider),
    );
  }
}
