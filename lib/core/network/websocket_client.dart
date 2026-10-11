import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class GreenhouseWebSocketClient {
  GreenhouseWebSocketClient({required this.wsBaseUrl});

  final String wsBaseUrl;
  WebSocketChannel? _channel;

  Stream<dynamic> connect(String greenhouseId) {
    final uri = Uri.parse('$wsBaseUrl/api/v1/ws/greenhouses/$greenhouseId');
    _channel = WebSocketChannel.connect(uri);
    return _channel!.stream;
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
