import 'package:flutter/material.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/providers/websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SessionViewModel extends ChangeNotifier{
  bool isAuthenticated = false;
  var currentUser = {};
  num nbeNotificationsNotRead = 0;
  num nbeMessagesNotRead = 0;
  String oneSignalId = '';
  late SharedPreferences sessionData;

  SessionViewModel(){
    initial();
  }

  void initial() async {
    this.sessionData = await SharedPreferences.getInstance();
    String? token = this.sessionData.getString(tokenCurrentUserStorage);
    print('SessionViewModel token : ${token}');
    if(token!=null){
      sessionUser();

      // Init WS
      initWebsocket();
    }
  }

  Future sessionUser() async {
    String newCurrentUser = this.sessionData.getString(currentUserStorage) ?? '';
    isAuthenticated = true;
    currentUser = (newCurrentUser!=null) ? json.decode(newCurrentUser) : {};
    nbeNotificationsNotRead = 0;
    nbeMessagesNotRead = 0;
    oneSignalId = '';
    notifyListeners();
  }


  Future logout() async {
    isAuthenticated = false;
    currentUser = {};
    nbeNotificationsNotRead = 0;
    nbeMessagesNotRead = 0;
    oneSignalId = '';
    notifyListeners();
  }

}
