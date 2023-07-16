import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sm/models/notification_class.dart';

class NotificationAPI {
  String url = 'https://fcm.googleapis.com/fcm/send';
  var headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization":
        "key=AAAA4QFCvx8:APA91bGPSOuIhCRj5nbXtWjh8DgwCX83uCCqwM9NEuf7iVHYC894v9JjQJihCG7kthp37TkDzCX4fwqvEZNr3sv_g8nyZZWBg-433GD1wzKNOTjFQ7WiLWFPEpgM5VdQfbWJ5XXN1Z7G"
  };

  sendNotification(NotificationClass notification) async {
    print(notification.toJson());
   var r=  await http.post(
        Uri.parse(url),
        body: jsonEncode(notification.toJson()),
        headers: headers
    );
   print(r.body);
  }
}
