import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String storedData;

  @override
  void initState() {
    super.initState();
    storedData = "Press Button to reload Data";
    //v2 reg.ister ios push notification service
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    } else {
      //_saveDeviceToken();
      //Just to re run job
    }
    //Subscribe to topic frontEND
    _fcm.subscribeToTopic("test");
    //Unsubscribe to topic
    //_fcm.unsubscribeFromTopic("Teneant");
    _fcm.configure(
      //Use for popups and ticks
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage :$message");
        var ms = message["data"];
        var type = ms["type"];
        var desc = ms["desc"];
        if (type == "0") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: AspectRatio(
                  aspectRatio: 1.5,
                  child: Text("tick MARK"),
                ),
                content: Text("$desc", textAlign: TextAlign.center)),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title:
                  AspectRatio(aspectRatio: 1.5, child: Text("Failed Response")),
              content: Text("$desc", textAlign: TextAlign.center),
            ),
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage :$message");
      },
      //App closed and you press notification
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage :$message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Hello Worldo"),
        ),
        body: Column(
          children: [
            Text("$storedData"),
            MaterialButton(onPressed: _readStoredData)
          ],
        ));
  }

  _readStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sData = prefs.getString('user_data') ?? "Hakuna Kitu";
    setState(() {
      storedData = sData;
    });
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user_data", jsonEncode(message));
  // if (message.containsKey('data')) {
  //   // Handle data message
  //   final dynamic data = message['data'];
  // }

  // if (message.containsKey('notification')) {
  //   // Handle notification message
  //   final dynamic notification = message['notification'];
  // }

  // Or do other work.
}
