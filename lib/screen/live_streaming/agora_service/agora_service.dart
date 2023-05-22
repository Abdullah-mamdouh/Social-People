

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/message.dart';

class AgoraService with ChangeNotifier {

  String baseUrl = 'https://agora-token-service-production-b890.up.railway.app';//agora-token-service-production-76e6.up.railway.app'; //Add the link to your deployed server here
  int uid = 30;
  String token = '';
  final _messagesInfo = <Message>[];
  List<Message> get getMessages => _messagesInfo;
  String get getLiveToken => token;

  setMessage(Message m){
    _messagesInfo.insert(0, m);
   // debugPrint(_messagesInfo[0].image);
    notifyListeners();
  }

  Future<void> getToken(String channelName, String uid) async {
    final response = await http.get(
      Uri.parse(baseUrl + '/rtc/' + '$channelName' + '/:role/uid/' +uid.toString() //Random().nextInt(10).toString()
        // To add expiry time uncomment the below given line with the time in seconds
        // + '?expiry=45'
      ),
    );

    if (response.statusCode == 200) {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
    } else {
      print('Failed to fetch the token');
    }
    debugPrint(token);
    notifyListeners();
  }

}