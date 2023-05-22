
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;
import 'package:sm/screen/live_streaming/utils/setting.dart';
import 'package:sm/service/authentication.dart';

import '../../service/firebaseOperation.dart';
import 'agora_service/agora_service.dart';
import 'utils/custom_button.dart';
import 'utils/responsive/resonsive_layout.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  final String username;
  final String uid;
  const BroadcastScreen({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
    required this.username,
    required this.uid
  }) : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  bool isScreenSharing = false;
  String? token;

  @override
  void initState() {
    super.initState();
    Provider.of<AgoraService>(context, listen: false).getToken(widget.channelId, widget.uid);
    token =  Provider.of<AgoraService>(context, listen: false).getLiveToken;
    _initEngine();
    if(widget.isBroadcaster)_storeLiveInFirebase();

  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }
  _storeLiveInFirebase(){
    Provider.of<FirebaseOperation>(context, listen: false)
        .uploadPostData(widget.channelId, {
      'post_image': 'https://firebasestorage.googleapis.com/v0/b/social-9064f.appspot.com/o/posts%2Fdata%2Fuser%2F0%2'
          'Fcom.example.sm%2Fcache%2Fvideo_live.png?alt=media&token=2ae211f6-1ef3-400c-b2c9-097569ec0660',
      'caption':'Live',
      'token':  token,
      'user_name':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserName,
      'user_image':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserImage,
      'user_uid': widget.uid,//Uuid().v1(),
      // Provider.of<Authentication>(context, listen: false)
      //     .getUserUid,
      'time': Timestamp.now(),
      'user_email':
      Provider.of<FirebaseOperation>(context, listen: false)
          .getUserEmail,
    })
        ;}
  String baseUrl = "https://twitch-tutorial-server.herokuapp.com";


  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          widget.uid +
          '/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _addListeners() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
          debugPrint('joinChannelSuccess $channel $uid $elapsed');
        }, userJoined: (uid, elapsed) {
          debugPrint('userJoined $uid $elapsed');
          setState(() {
            remoteUid.add(uid);
          });
        }, userOffline: (uid, reason) {
          debugPrint('userOffline $uid $reason');
          setState(() {
            remoteUid.removeWhere((element) => element == uid);
          });
        }, leaveChannel: (stats) {
          debugPrint('leaveChannel $stats');
          setState(() {
            remoteUid.clear();
          });
        }, tokenPrivilegeWillExpire: (token) async {
          await getToken();
          await _engine.renewToken(token);
        }));
  }

  void _joinChannel() async {
    await getToken();
    if (token != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await [Permission.microphone, Permission.camera].request();
      }
      await _engine.joinChannelWithUserAccount(
        token,
        widget.channelId,
        widget.uid,
      );
    }
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  _startScreenShare() async {
    final helper = _engine;
    // await _engine.getScreenShareHelper(
    //     appGroup: kIsWeb || Platform.isWindows ? null : 'io.agora');
    await helper.disableAudio();
    await helper.enableVideo();
    await helper.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await helper.setClientRole(ClientRole.Broadcaster);
    var windowId = 0;
    var random = Random();
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isAndroid)) {
      // final windows = _engine.enumerateWindows();
      // if (windows.isNotEmpty) {
      //   final index = random.nextInt(windows.length - 1);
      //   debugPrint('Screensharing window with index $index');
      //   windowId = windows[index].id;
      // }
    }
    //await helper.startstartScreenCaptureByWindowId(windowId);
    setState(() {
      isScreenSharing = true;
    });
    await helper.joinChannelWithUserAccount(
      token,
      widget.channelId,
      widget.uid,
    );
  }
/*
  _stopScreenShare() async {
    final helper = await _engine.getScreenShareHelper();
    await helper.destroy().then((value) {
      setState(() {
        isScreenSharing = false;
      });
    }).catchError((err) {
      debugPrint('StopScreenShare $err');
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${Provider.of<Authentication>(context, listen: false).user.uid}${Provider.of<Authentication>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
*/
  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<Authentication>(context).getUserUid;

    return WillPopScope(
      onWillPop: () async {
        //await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: widget.isBroadcaster
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: CustomButton(
            text: 'End Stream', onTap: () {  },
            //onTap: _leaveChannel,
          ),
        )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ResponsiveLatout(
            desktopBody: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _renderVideo(widget.uid,widget.username, isScreenSharing),
                      if ("${widget.uid}${widget.username}" == widget.channelId)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: _switchCamera,
                              child: const Text('Switch Camera'),
                            ),
                            InkWell(
                              onTap: onToggleMute,
                              child: Text(isMuted ? 'Unmute' : 'Mute'),
                            ),
                            InkWell(
                              // onTap: isScreenSharing
                              //     ? _stopScreenShare
                              //     : _startScreenShare,
                              child: Text(
                                isScreenSharing
                                    ? 'Stop ScreenSharing'
                                    : 'Start Screensharing',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                //Chat(channelId: widget.channelId),
              ],
            ),
            mobileBody: Column(
              children: [
                _renderVideo(widget.uid, widget.username, isScreenSharing),
                if ("${widget.uid}${widget.username}" == widget.channelId)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: _switchCamera,
                        child: const Text('Switch Camera'),
                      ),
                      InkWell(
                        onTap: onToggleMute,
                        child: Text(isMuted ? 'Unmute' : 'Mute'),
                      ),
                    ],
                  ),
                /*Expanded(
                  child: Chat(
                    channelId: widget.channelId,
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderVideo(username,uid, isScreenSharing) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${uid}${username}" == widget.channelId
          ? isScreenSharing
          ? kIsWeb
          ? RtcLocalView.SurfaceView()
          :  RtcLocalView.TextureView()
          :  RtcLocalView.SurfaceView(
        zOrderMediaOverlay: true,
        zOrderOnTop: true,
      )
          : isScreenSharing
          ? kIsWeb
          ?  RtcLocalView.SurfaceView()
          :  RtcLocalView.TextureView()
          : remoteUid.isNotEmpty
          ? kIsWeb
          ? RtcRemoteView.SurfaceView(
        uid: remoteUid[0],
        channelId: widget.channelId,
      )
          : RtcRemoteView.TextureView(
        uid: remoteUid[0],
        channelId: widget.channelId,
      )
          : Container(),
    );
  }
}
