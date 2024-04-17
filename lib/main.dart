import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:powerstone/firebase_options.dart';
import 'package:powerstone/services/auth/auth_gate.dart';
import 'package:powerstone/services/theme.dart';

//function to listen to background changes
@pragma('vm:entry-point')
Future _firebaseNotificationBackgroudMessage(RemoteMessage message)async{
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  //listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseNotificationBackgroudMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POWERSTONE',
      debugShowCheckedModeBanner: false,
      theme: apptheme,
      home: const AuthGate(),
    );
  }
}
