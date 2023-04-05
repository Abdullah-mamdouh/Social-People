import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:math' as math;

import '../../../service/authentication.dart';
import '../../../service/firebaseOperation.dart';
import '../HearAnim.dart';
import '../firebaseDB/firestoreDB.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../utils/setting.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  final String image;
  final time;
  /// Creates a call page with given channel name.
  const CallPage({Key? key, required this.channelName, this.time,required this.image}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage>{
  static final _users = <int>[];
  List<User> userList = [];

  bool _isLogin = true;
  bool _isInChannel = true;
  int userNo = 0;
  var userMap ;
  var tryingToEnd = false;
  bool personBool = false;
  bool accepted =false;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <Message>[];

  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  bool heart = false;
  bool anyPerson = false;

  //Love animation
  final _random = math.Random();
  Timer? _timer;
  double height = 0.0;
  int _numConfetti = 5;
  int guestID=-1;
  bool waiting=false;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    userMap = {widget.channelName: widget.image};
    _createClient();
    _storeLiveInFirebase();
  }


  _storeLiveInFirebase(){
    Provider.of<FirebaseOperation>(context, listen: false)
        .uploadPostData(widget.channelName, {
      'post_image': 'https://firebasestorage.googleapis.com/v0/b/social-9064f.appspot.com/o/posts%2Fdata%2Fuser%2F0%2'
          'Fcom.example.sm%2Fcache%2Fvideo_live.png?alt=media&token=2ae211f6-1ef3-400c-b2c9-097569ec0660',
      'caption':'Live',
      'user_name':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserName,
      'user_image':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserImage,
      'user_uid':
      Provider.of<Authentication>(context, listen: false)
          .getUserUid,
      'time': Timestamp.now(),
      'user_email':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserEmail,
    })
    //     .whenComplete(() {
    //   return FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(Provider.of<Authentication>(context,
    //       listen: false)
    //       .getUserUid)
    //       .collection('posts')
    //       .add({
    //     'post_image': getuploadPostImageUrl,
    //     'caption': captionController.text,
    //     'user_name': Provider.of<FirebaseOperation>(context,
    //         listen: false)
    //         .getUserName,
    //     'user_image': Provider.of<FirebaseOperation>(context,
    //         listen: false)
    //         .getUserImage,
    //     'user_uid':
    //     Provider.of<Authentication>(context, listen: false)
    //         .getUserUid,
    //     'time': Timestamp.now(),
    //     'user_email': Provider.of<FirebaseOperation>(context,
    //         listen: false)
    //         .getUserEmail,
    //   });
    // })
    ;}



  Future<void> initialize() async {

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    //await RtcEngine.enableVideo();
    // await RtcEngine.enableLocalAudio(true);

    //_engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    await _engine.enableVideo();
    await _engine.enableLocalAudio(true);
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // if (widget.isBroadcaster) {
    //   await _engine.setClientRole(ClientRole.Broadcaster);
    // } else {
    //   await _engine.setClientRole(ClientRole.Audience);
    // }

  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    RtcEngineEventHandler(
      joinChannelSuccess: (
          String channel,
          int uid,
          int elapsed,
          ) async{

        final documentId = widget.channelName;
        FireStoreClass.createLiveUser(name: documentId,id: uid,time: widget.time,image:widget.image);
        // The above line create a document in the firestore with username as documentID

        await Wakelock.enable();
        // This is used for Keeping the device awake. Its now enabled

      },
      userJoined: (int uid, int elapsed) {
        setState(() {
          _users.add(uid);
        });
      },

      userOffline: (int uid, UserOfflineReason reason) {
        if(uid == guestID){
          setState(() {
            accepted=false;
          });
        }
        setState(() {
          _users.remove(uid);
        });
      },
    );
    // AgoraRtcEngine.onLeaveChannel = () {
    //   setState(() {
    //     _users.clear();
    //   });
    // };

  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final list = [
      RtcLocalView.SurfaceView(),
    ];
    return list;
   /* final List<Widget> list = [
      // RenderWidget(0, local: true, preview: true),
    ];
    if(accepted==true) {
      _users.forEach((int uid) {
        if(uid!=0){
          guestID = uid;
        }
        // list.add(RenderWidget(uid));
      });
    }
    return list;*/
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: ClipRRect(child: view));
  }


  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }


  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
    }
    return Container();


    /*    return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ));*/
  }


  void popUp() async{
    setState(() {
      heart=true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });

    Timer(const Duration(seconds: 4), () =>
    {
      _timer!.cancel(),
      setState(() {
        heart=false;
      })
    });
  }
  Widget heartPop(){
    final size = MediaQuery.of(context).size;
    final confetti = <Widget>[];
    for (var i = 0; i < _numConfetti; i++) {
      final height = _random.nextInt(size.height.floor());
      final width = 20;
      confetti.add(HeartAnim(height % 200.0,
        width.toDouble(), 0.5,));
    }


    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 400,
            width: 200,
            child: Stack(
              children: confetti,
            ),
          ),
        ),
      ),
    );
  }



  /// Info panel to show logs
  Widget messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {

              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoStrings[index].type=='join')? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: _infoStrings[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const  EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Text(
                          '${_infoStrings[index].user} joined',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : (_infoStrings[index].type=='message')?
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: _infoStrings[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const  EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              _infoStrings[index].user,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Padding(
                            padding: const  EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              _infoStrings[index].message,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
                    :null,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Future<bool> _willPopCallback() async {
    if(personBool==true){
      setState(() {
        personBool=false;
      });

    }else {
      setState(() {
        tryingToEnd = !tryingToEnd;
      });
    }
    return false;// return true if the route to be popped
  }

  Widget _endCall(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15,15,15,15),
            child: GestureDetector(
              onTap: () {
                if(personBool==true){
                  setState(() {
                    personBool=false;
                  });
                }
                setState(() {
                  if(waiting==true){
                    waiting=false;
                  }
                  tryingToEnd=true;
                });
              },
              child: const Text('END',style: TextStyle(color: Colors.indigo,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveText(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.indigo, Colors.blue
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
                child: Text('LIVE',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:5,right:10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: const BorderRadius.all(const Radius.circular(4.0))
                  ),
                  height: 28,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(FontAwesomeIcons.eye,color: Colors.white,size: 13,),
                        const SizedBox(width: 5,),
                        Text('$userNo',style: const TextStyle(color: Colors.white,fontSize: 11),),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget endLive(){
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                'Are you sure you want to end your live video?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize:20
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 4.0,top:8.0,bottom:8.0),
                    child: RaisedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: const Text('End Video',style: const TextStyle(color: Colors.white),),
                      ),
                      elevation: 2.0,
                      color: Colors.blue,
                      onPressed: () async{
                        await Wakelock.disable();
                        _logout();
                        _leaveChannel();
                        _engine.leaveChannel();
                        _engine.destroy();
                        //FireStoreClass.deleteUser(username: channelName);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0,right: 8.0,top:8.0,bottom:8.0),
                    child: RaisedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text('Cancel',style: TextStyle(color:Colors.white),),
                      ),
                      elevation: 2.0,
                      color: Colors.grey,
                      onPressed: (){
                        setState(() {
                          tryingToEnd=false;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget personList(){
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 2*MediaQuery.of(context).size.height/3,
        width: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          color: Colors.grey[850],
          borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight: const Radius.circular(25)
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 2*MediaQuery.of(context).size.height/3 -50,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: const Text('Go Live with',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                  const SizedBox(height: 10,),
                  Divider(color: Colors.grey[800],thickness: 0.5,height: 0,),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: Text(
                      'When you go live with someone, anyone who can watch their live videos will be able to watch it too.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  anyPerson==true?Container(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      width: double.maxFinite,
                      child: const Text(
                        'INVITE',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                      )
                  ):
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('No Viewers',style: TextStyle(color: Colors.grey[400]),),
                  ),
                  Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: getUserStories()
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    personBool= !personBool;
                  });
                },
                child: Container(
                  color: Colors.grey[850],
                  alignment: Alignment.bottomCenter,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: double.maxFinite,
                          alignment: Alignment.center ,
                          child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (User users in userList) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(User users) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: ()async{
              setState(() {
                waiting=true;
              });
              await _channel!.sendMessage(AgoraRtmMessage.fromText('d1a2v3i4s5h6 ${users.username}'));
            },
            child: Container(
                padding: const EdgeInsets.only(left: 15),
                color: Colors.grey[850 ],
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: users.image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Text(users.username,style: const TextStyle(fontSize: 18,color: Colors.white),),
                          const SizedBox(height: 2,),
                          Text(users.name,style: const TextStyle(color: Colors.grey),),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget stopSharing(){
    return Container(
      height: MediaQuery.of(context).size.height/2+40,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MaterialButton(
          minWidth: 0,
          onPressed: ()async{
            stopFunction();
            await _channel!.sendMessage(AgoraRtmMessage.fromText('E1m2I3l4i5E6 stoping'));
          },
          child: const Icon(
            Icons.clear,
            color: Colors.white,
            size: 15.0,
          ),
          shape: const CircleBorder(),
          elevation: 2.0,
          color: Colors.blue[400],
          padding: const EdgeInsets.all(5.0),
        ),
      ),
    );
  }

  Widget guestWaiting(){
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
          height: 100,
          width: double.maxFinite,
          alignment: Alignment.center,
          color: Colors.black,
          child: Wrap(
            children: <Widget>[
              const Text('Waiting for the user to accept...',style: const TextStyle(color: Colors.white,fontSize: 20),)
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(),// Video Widget
                    if(tryingToEnd==false)_endCall(),
                    if(tryingToEnd==false)_liveText(),
                    if(heart == true && tryingToEnd==false) heartPop(),
                    if(tryingToEnd==false) _bottomBar(), // send message
                    if(tryingToEnd==false)messageList(),
                    if(tryingToEnd==true)endLive(),// view message
                    if(personBool==true && waiting==false) personList(),
                    if(accepted == true) stopSharing(),
                    if(waiting == true) guestWaiting(),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback
    );
  }
// Agora RTM

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left:8,top:5,right: 8,bottom: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,0,0,0),
                      child: new TextField(
                          cursorColor: Colors.blue,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _sendMessage,
                          style: const TextStyle(color: Colors.white),
                          controller: _channelMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Comment',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Colors.white)
                            ),
                          )
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: _toggleSendChannelMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    color: Colors.blue[400],
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                if(accepted==false)Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: _addPerson,
                    child: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    color:Colors.blue[400] ,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                  child: MaterialButton(
                    minWidth: 0,
                    onPressed: _onSwitchCamera,
                    child: Icon(
                      Icons.switch_camera,
                      color: Colors.blue[400],
                      size: 20.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    color: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  void _addPerson() {
    setState(() {
      personBool = !personBool;
    });
  }

  void stopFunction(){
    setState(() {
      accepted= false;
    });
  }


  void _logout() async {
    try {
      await _client!.logout();
      //_log(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }



  void _leaveChannel() async {
    try {
      await _channel!.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      _client!.releaseChannel(_channel!.channelId!);
      _channelMessageController.text = '';

    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel!.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.channelName, info: text,type: 'message');
    } catch (errorCode) {
      //_log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel!.sendMessage(AgoraRtmMessage.fromText(text));
      _log(user: widget.channelName, info:text,type: 'message');
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _createClient() async {
    _client =
    await AgoraRtmClient.createInstance(APP_ID);
    _client!.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(user: peerId,  info: message.text, type: 'message');
    };
    _client!.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client!.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client!.login(null, widget.channelName );
    _channel = await _createChannel(widget.channelName);
    await _channel!.join();
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client!.createChannel(name);
    channel!.onMemberJoined = (AgoraRtmMember member) async {
      var img = 'asstes/icons/task.png';//await FireStoreClass.getImage(username: member.userId);
      var nm = 'ALi Ali';//await FireStoreClass.getName(username: member.userId);
      setState(() {
        userList.add(new User(username: member.userId, name: nm, image: img));
        if(userList.length>0)
          anyPerson =true;
      });
      userMap.putIfAbsent(member.userId, () => img);
      var len;
      _channel!.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo= len-1 ;
        });
      });

      _log(info: 'Member joined: ',  user: member.userId,type: 'join');
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var len;
      setState(() {
        userList.removeWhere((element) => element.username == member.userId);
        if(userList.length==0)
          anyPerson = false;
      });

      _channel!.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo= len-1 ;
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _log(user: member.userId, info: message.text,type: 'message');
    };
    return channel;
  }

  void _log({String? info,String? type,String? user}) {
    if(type=='message' && info!.contains('m1x2y3z4p5t6l7k8')){
      popUp();
    }
    else if(type=='message' && info!.contains('k1r2i3s4t5i6e7')){
      setState(() {
        accepted=true;
        personBool=false;
        personBool=false;
        waiting= false;
      });
    }
    else if(type=='message' && info!.contains('E1m2I3l4i5E6')){
      stopFunction();
    }
    else if(type=='message' && info!.contains('R1e2j3e4c5t6i7o8n9e0d')){
      setState(() {
        waiting=false;
      });
      /*FlutterToast.showToast(
          msg: "Guest Declined",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

    }
    else {
      var image = userMap[user];
      Message m = new Message(
          message: info!, type: type!, user: user!, image: image);
      setState(() {
        _infoStrings.insert(0, m);
      });
    }
  }
}
