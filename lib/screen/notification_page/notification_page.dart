
import 'package:flutter/material.dart';
import 'package:sm/screen/notification_page/widgets/notification_widget.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key,}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return NotificationsWidget();
  }
}
