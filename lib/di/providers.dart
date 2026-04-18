import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/double_click_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/left_click_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/mouse_down_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/mouse_up_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/right_click_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/scroll_usecase.dart';
import 'package:pc_remote/features/remote_control/domain/usecases/swipe_usecase.dart';

import '../features/connection/data/datasources/connection_socket_datasource.dart';
import '../features/connection/data/repositories/connection_repository_impl.dart';
import '../features/connection/domain/usecases/connect_usecase.dart';
import '../features/connection/domain/usecases/disconnect_usecase.dart';
import '../features/connection/domain/usecases/observe_connection_usecase.dart';
import '../features/connection/presentation/notifier/connection_notifier.dart';
import '../features/remote_control/data/datasources/remote_socket_datasource.dart';
import '../features/remote_control/data/repositories/remote_repository_impl.dart';
import '../features/remote_control/domain/usecases/move_mouse_usecase.dart';
import '../socket/client/socket_client.dart';
import '../socket/event_bus/socket_event_bus.dart';

final eventBusProvider = Provider((ref) => SocketEventBus());

final socketClientProvider = Provider((ref) => SocketClient());

final connectionDatasourceProvider = Provider(
  (ref) => ConnectionSocketDatasource(ref.read(socketClientProvider)),
);

final connectionRepositoryProvider = Provider(
  (ref) => ConnectionRepositoryImpl(ref.read(connectionDatasourceProvider)),
);

final connectUseCaseProvider = Provider(
  (ref) => ConnectUseCase(ref.read(connectionRepositoryProvider)),
);

final disconnectUseCaseProvider = Provider(
  (ref) => DisconnectUseCase(ref.read(connectionRepositoryProvider)),
);

final observeConnectionUseCaseProvider = Provider(
  (ref) => ObserveConnectionUseCase(ref.read(connectionRepositoryProvider)),
);

final connectionNotifierProvider = NotifierProvider<ConnectionNotifier, bool>(
  ConnectionNotifier.new,
);

final remoteDatasourceProvider = Provider(
  (ref) => RemoteSocketDatasource(ref.read(socketClientProvider)),
);

final remoteRepositoryProvider = Provider(
  (ref) => RemoteRepositoryImpl(ref.read(remoteDatasourceProvider)),
);

final moveMouseUseCaseProvider = Provider(
  (ref) => MoveMouseUseCase(ref.read(remoteRepositoryProvider)),
);

final leftClickUseCaseProvider = Provider(
  (ref) => LeftClickUseCase(ref.read(remoteRepositoryProvider)),
);

final rightClickUseCaseProvider = Provider(
  (ref) => RightClickUseCase(ref.read(remoteRepositoryProvider)),
);

final doubleClickUseCaseProvider = Provider(
  (ref) => DoubleClickUseCase(ref.read(remoteRepositoryProvider)),
);

final mouseDownUseCaseProvider = Provider(
  (ref) => MouseDownUseCase(ref.read(remoteRepositoryProvider)),
);

final mouseUpUseCaseProvider = Provider(
  (ref) => MouseUpUseCase(ref.read(remoteRepositoryProvider)),
);

final scrollUseCaseProvider = Provider(
  (ref) => ScrollUseCase(ref.read(remoteRepositoryProvider)),
);
final threeFingerSwipeUseCaseProvider = Provider(
  (ref) => SwipeUseCase(ref.read(remoteRepositoryProvider)),
);
