class SocketMessage {
  final String type;
  final Map<String, dynamic> payload;

  SocketMessage({required this.type, required this.payload});

  Map<String, dynamic> toJson() => {"type": type, "payload": payload};

  factory SocketMessage.fromJson(Map data) {
    return SocketMessage(
      type: data["type"],
      payload: Map<String, dynamic>.from(data["payload"]),
    );
  }
}
