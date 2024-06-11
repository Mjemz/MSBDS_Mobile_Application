import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        setState(() {
          notifications.add({
            'title': message.notification?.title ?? 'No Title',
            'message': message.notification?.body ?? 'No Message',
            'timestamp': DateTime.now().toString(),
          });
        });
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        setState(() {
          notifications.add({
            'title': message.notification?.title ?? 'No Title',
            'message': message.notification?.body ?? 'No Message',
            'timestamp': DateTime.now().toString(),
          });
        });
      });

      // Request permissions for iOS
      FirebaseMessaging.instance.requestPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]['title']),
            subtitle: Text(notifications[index]['message']),
            trailing: Text(notifications[index]['timestamp']),
          );
        },
      ),
    );
  }
}
