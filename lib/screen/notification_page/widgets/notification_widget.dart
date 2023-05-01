import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/Constantcolors.dart';
import '../../../service/authentication.dart';
import '../notiication_helper.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'notifications'.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Provider.of<NotificationHelper>(context,
                          listen: false)
                      .getNotifications(
                          context,
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }
                    return Column(
                      children: snapshot.data!.docs
                          .map<Widget>((DocumentSnapshot document) {
                            return _buildNotificationWidget(document);
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildNotificationWidget(var document) {
    //debugPrint(document['user_image']);
    return Container(
      color: constantColors.darkColor,
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image(
              image: NetworkImage('${document['user_image']}'),fit: BoxFit.cover,
              height: 70,
              width: 70,
            ),
          ),
          SizedBox(
            width:8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '${document['user_name']}',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${ timeformat(document['time'])}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Text(
                '${document['typeNotifier']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

timeformat(dynamic timeData){
  Timestamp time = timeData ;
  DateTime dateTime = time.toDate();
  return timeago.format(dateTime);
}