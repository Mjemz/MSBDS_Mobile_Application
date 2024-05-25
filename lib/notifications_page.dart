import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> notifications = [];

  Future<void> fetchNotifications() async {
    // Our current web application doesn't have a web hosting
    final response = await http.get(Uri.parse('https:localhost8080/notifications/'));

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]['title']),
            subtitle: Text(notifications[index]['message']),
            trailing: Text(notifications[index]['timestamp'].toString()),
          );
        },
      ),
    );
  }
}

