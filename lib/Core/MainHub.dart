import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:logging/logging.dart';

// If you want only to log out the message for the higer level hub protocol:
final hubProtLogger = Logger("SignalR - hub");

class MainHub {
  HubConnection? _hubConnection;

  HubConnection? get hubConnection => _hubConnection!;

  MainHub._internal();

  static final MainHub _instance = MainHub._internal();

  factory MainHub() {
    return _instance;
  }

  Future<void> Connect(String token) async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    final hubProtLogger = Logger("SignalR - hub");
    final transportProtLogger = Logger("SignalR - transport");

    _hubConnection ??= HubConnectionBuilder()
        .withUrl(Httpbase().baseUrl + '/hub',
            options: HttpConnectionOptions(
                accessTokenFactory: () => Future.value(token),
                logger: transportProtLogger))
        .configureLogging(hubProtLogger)
        .withAutomaticReconnect(retryDelays: [500, 1000, 2000, 3000]).build();
    await _hubConnection!.start();

    _hubConnection!.onclose(({error}) {
      print("HUBCONNECTION ONCLOSE ERROR: ${error ?? "no error"}");
      return;
    });

    _hubConnection!.onreconnecting(({error}) {
      print("HUBCONNECTION RECONNECTING ERROR: ${error ?? "no error"}");
      return;
    });

    _hubConnection!.onreconnected(({connectionId}) {
      print(
          "HUBCONNECTION RECONNECTED CONNECTION ID: ${connectionId ?? "no id"}");
      return;
    });
  }

  Future<void> Disconnect() async {
    await _hubConnection!.stop();
  }
}
