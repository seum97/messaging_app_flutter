
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_messaging_app/pages/auth/authListener.dart';
import 'package:new_messaging_app/service/notificationService.dart';

import 'firebase_options.dart';
import 'notification/notificationDestinationPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.requestNotificationPermission();
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthListener(),
      routes: {
        '/notice_page' : (context) => NotificationDestination(),
      },
    );
  }
}



