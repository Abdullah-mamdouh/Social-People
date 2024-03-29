import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfileHelper.dart';
import 'package:sm/screen/alt_profile/chat_helper.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoomHelper.dart';
import 'package:sm/screen/chat_room/single_chat/singleChatsHelper.dart';
import 'package:sm/screen/feed/feedHelper.dart';
import 'package:sm/screen/home_page/homePageHelper.dart';
import 'package:sm/screen/landing_page/landingHelper.dart';
import 'package:sm/screen/landing_page/landingService.dart';
import 'package:sm/screen/landing_page/landingUtils.dart';
import 'package:sm/screen/live_streaming/agora_service/agora_service.dart';
import 'package:sm/screen/messaging/group/groupMessageHelper.dart';
import 'package:sm/screen/messaging/single/singleChatMessageHelper.dart';
import 'package:sm/screen/notification_page/notiication_helper.dart';
import 'package:sm/screen/profile/profileHelper.dart';
import 'package:sm/screen/splash_screen/splashScreen.dart';
import 'package:sm/screen/stories/storiesHelper.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:sm/utils/postOption.dart';
import 'package:sm/utils/theme_mode/theme.dart';
import 'package:sm/utils/uploadPost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = new ConstantColors();
    return MultiProvider(
      child: ChangeNotifierProvider(
        create: (context) => ThemeColor(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeColor>(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: Provider.of<ThemeColor>(context).themeMode,
        //themeMode: Provider.of<ThemeHelper>(context).themeMode,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: SplashPage(),
      );

    }
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => AgoraService()),
        ChangeNotifierProvider(create: (_) => ChatHelper()),
        ChangeNotifierProvider(create: (_) => NotificationHelper()),
        ChangeNotifierProvider(create: (_) => SingleChatsHelper()),
        ChangeNotifierProvider(create: (_) => SingleChatMessageHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (_) => StoriesHepher()),
        ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
        ChangeNotifierProvider(create: (_) => AltProfileHlper()),
        ChangeNotifierProvider(create: (_) => PostFunction()),
        ChangeNotifierProvider(create: (_) => FeedHelper()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => ProfileHelper()),
        ChangeNotifierProvider(create: (_) => HomePageHelper()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => FirebaseOperation()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingHelper()),
      ],
    );
  }
}