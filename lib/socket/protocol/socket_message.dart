class SocketMessage<T> {
  final String type;
  final T payload;

  const SocketMessage({
    required this.type,
    required this.payload,
  });

  Map<String, dynamic> toJson({
    required Map<String, dynamic> Function(T value) toMap,
  }) {
    return {
      "type": type,
      "payload": toMap(payload),
    };
  }

  factory SocketMessage.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic json) fromMap,
  }) {
    return SocketMessage<T>(
      type: json["type"],
      payload: fromMap(json["payload"]),
    );
  }
}
