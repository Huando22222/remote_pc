import '../../../../socket/event_bus/socket_event_bus.dart';
import '../../../../socket/protocol/socket_message.dart';
import '../../../../socket/protocol/message_types.dart';

class ClipboardDatasource {
  final SocketEventBus eventBus;

  ClipboardDatasource(this.eventBus);

  void sendClipboard(String text) {
    eventBus.emit(
      SocketMessage(type: MessageTypes.clipboardSync, payload: {"text": text}),
    );
  }

  Stream<String> listenClipboard() {
    return eventBus
        .on(MessageTypes.clipboardSync)
        .map((msg) => msg.payload["text"]);
  }
}
