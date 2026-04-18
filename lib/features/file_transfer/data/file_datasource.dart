import '../../../socket/event_bus/socket_event_bus.dart';
import '../../../socket/protocol/message_types.dart';
import '../../../socket/protocol/socket_message.dart';

class FileDatasource {
  final SocketEventBus eventBus;

  FileDatasource(this.eventBus);

  void sendFileInfo(String name, int size) {
    eventBus.emit(
      SocketMessage(
        type: MessageTypes.fileUpload,
        payload: {"name": name, "size": size},
      ),
    );
  }

  void sendChunk(List<int> chunk) {
    eventBus.emit(
      SocketMessage(type: MessageTypes.fileChunk, payload: {"chunk": chunk}),
    );
  }
}
