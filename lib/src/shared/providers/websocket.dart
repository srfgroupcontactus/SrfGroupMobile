import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/utils/interceptor.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:shared_preferences/shared_preferences.dart';


StompClient? stompClient;

Future<void> initWebsocket() async {

  final cache = await SharedPreferences.getInstance();
  final token = cache.getString(appToken);

  void onConnect(StompFrame frame) {
    print('onConnect');

    sendConnectedNewUser();

    subscribeConnectedUsers();

  }

  if (stompClient == null) {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: '${APP_API_END_POINT}websocket/tracker?access_token=',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer ${token}'},
        webSocketConnectHeaders: {'Authorization': 'Bearer ${token}'},
      ),
    );
    stompClient?.activate();
  }
}

void sendConnectedNewUser() async{
  var prefs = await SharedPreferences.getInstance();
  String newCurrentUser = prefs.getString(currentUserStorage) ?? '';
  stompClient!.send(
    destination: '/topic/user.connectedUser',
    body: newCurrentUser,
  );
}

void subscribeConnectedUsers() async{
  stompClient!.subscribe(
    destination: '/topic/connected-user',
    callback: (frame) {
      print('frame.body ${frame.body}');
    },
  );
}

void disconnectWS(){
  stompClient?.deactivate();
}
