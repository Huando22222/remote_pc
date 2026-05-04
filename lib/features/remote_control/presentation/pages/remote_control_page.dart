import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/swipe_usecase.dart';
import 'package:pc_remote/features/remote_control/presentation/widgets/touchpad_widget.dart';
import '../../../../di/providers.dart';
import '../../domain/usecases/move_mouse_usecase.dart';
import '../../domain/usecases/left_click_usecase.dart';
import '../../domain/usecases/right_click_usecase.dart';
import '../../domain/usecases/double_click_usecase.dart';
import '../../domain/usecases/mouse_down_usecase.dart';
import '../../domain/usecases/mouse_up_usecase.dart';
import '../../domain/usecases/scroll_usecase.dart';

class RemoteControlPage extends ConsumerStatefulWidget {
  const RemoteControlPage({super.key});

  @override
  ConsumerState<RemoteControlPage> createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends ConsumerState<RemoteControlPage> {
  // lấy usecase 1 lần duy nhất, không bị reset khi rebuild
  late final MoveMouseUseCase _moveMouse;
  late final LeftClickUseCase _leftClick;
  late final RightClickUseCase _rightClick;
  late final DoubleClickUseCase _doubleClick;
  late final MouseDownUseCase _mouseDown;
  late final MouseUpUseCase _mouseUp;
  late final ScrollUseCase _scroll;
  late final SwipeUseCase _swipe;

  @override
  void initState() {
    super.initState();
    _moveMouse = ref.read(moveMouseUseCaseProvider);
    _leftClick = ref.read(leftClickUseCaseProvider);
    _rightClick = ref.read(rightClickUseCaseProvider);
    _doubleClick = ref.read(doubleClickUseCaseProvider);
    _mouseDown = ref.read(mouseDownUseCaseProvider);
    _mouseUp = ref.read(mouseUpUseCaseProvider);
    _scroll = ref.read(scrollUseCaseProvider);
    _swipe = ref.read(threeFingerSwipeUseCaseProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Remote Touchpad")),
      body: Column(
        children: [
          Expanded(
            child: TouchpadWidget(
              moveMouse: _moveMouse,
              leftClick: _leftClick,
              rightClick: _rightClick,
              doubleClick: _doubleClick,
              mouseDown: _mouseDown,
              mouseUp: _mouseUp,
              scroll: _scroll,
              swipe: _swipe,
            ),
          ),
        ],
      ),
    );
  }
}
