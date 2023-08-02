import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            const Text('Manage Events'),
          ],
        ),
      ),
    );
  }
}
