import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      body: Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
