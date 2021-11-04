import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/messaging/group/groupMessage.dart';
import 'package:sm/service/authentication.dart';

class SingleChatSearching extends SearchDelegate {
  //List<bool> isfavourite = List.filled(20, false);
  final _textController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            print(_textController.text);
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('singlechats').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
              var friendData = document['members'][0];
              Provider.of<Authentication>(context, listen: false).getUserUid ==
                      friendData['user_uid']
                  ? friendData
                  : friendData = document['members'][1];
              if (friendData['user_name']
                      .toLowerCase()
                      .compareTo(query.toLowerCase()) ==
                  0) {
                return
                  // GestureDetector(
                  // onTap: () {
                  //   Navigator.pushReplacement(
                  //       context,
                  //       PageTransition(
                  //           child: GroupMessage(
                  //             documentSnapshot: friendData,
                  //           ),
                  //           type: PageTransitionType.leftToRight));
                  // },
                  // child:
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(friendData['user_image']),
                        backgroundColor: constantColors.greyColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        friendData['user_name'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                //   ,
                // )
                ;
              }
            }),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search GroupsChat'),
    );
  }
}
