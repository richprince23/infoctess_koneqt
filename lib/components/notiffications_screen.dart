import 'package:flutter/material.dart';

class NotificationsSceen extends StatefulWidget {
  const NotificationsSceen({super.key});

  @override
  State<NotificationsSceen> createState() => _NotificationsSceenState();
}

class _NotificationsSceenState extends State<NotificationsSceen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Notifications"),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: const Text("Notifications"),
          ),
        ),
      ),
    );
  }
}
