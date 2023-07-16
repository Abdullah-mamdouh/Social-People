

class NotificationClass {
  String? to;
  String? priority;
  NotificationData? notification;
  Data? data;

  NotificationClass({this.to, this.priority = 'high', this.notification, this.data});

  NotificationClass.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    priority = json['priority'];
    notification = json['notification'] != null
        ? new NotificationData.fromJson(json['notification'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    data['priority'] = this.priority;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationData {
  String? title;
  String? body;

  NotificationData({this.title, this.body});

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title!;
    data['body'] = this.body;
    return data;
  }
}

class Data {
  String? type;
  String? id;

  Data({this.type, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
