import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:powerstone/common/notification.dart';
import 'package:powerstone/navigation_menu.dart';

class FCMNotificationServices {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permission');
    } else {
      print('User Denied Permission');
    }
  }

  Future<String?> getDeviceToken() async {
    final token = await messaging.getToken();
    print('DEVICE TOKEN: $token');
    return token;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('REFRESH');
    });
  }

  void handleMessage(BuildContext context , RemoteMessage message) {
    print('has entered handle message');
    print('TYPE: ${message.data.toString()}');
    if (message.data['type'] == 'notification') {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationPage()));
    }
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NavigationMenu(initialPageIndex: 3,)));
    }
  }

  void initLocalNotifications(BuildContext context , RemoteMessage message) async{
    var androidinitialization = const AndroidInitializationSettings('@drawable/logo');
    var initializeSettings = InitializationSettings(
      android: androidinitialization
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(context, message);
      }
    );
  }

  void firebaseInit(BuildContext context) {
    messaging.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen((message) {
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
      }
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async{
     AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'High Importance notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(), 
      channel.name.toString(),
      channelDescription: 'my channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@drawable/logo', // Specify the small icon resource
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  }

  Future <void> setupInteractMessage(BuildContext context)async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage!=null){
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    //When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

}
