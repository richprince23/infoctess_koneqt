import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/components/starred_item.dart';

class StarredMessagesScreen extends StatefulWidget {
  const StarredMessagesScreen({Key? key}) : super(key: key);

  @override
  StarredMessagesScreenState createState() => StarredMessagesScreenState();
}

class StarredMessagesScreenState extends State<StarredMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Starred Messages"),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("clear all"),
          ),
        ],
      ),
      body: FutureBuilder(builder: (context, snapshot) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Slidable(
              direction: Axis.horizontal,
              endActionPane: ActionPane(
                  // extentRatio: 0.2,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      autoClose: true,
                      label: "Delete",
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) {},
                    ),
                    SlidableAction(
                      autoClose: true,
                      label: "Unstar",
                      backgroundColor: Colors.yellow,
                      icon: Icons.star_border,
                      onPressed: (context) {},
                    ),
                  ]),
              child: const ListTile(
                title: StarredItem(),
              ),
            );
          },
        );
      }),
    );
  }
}
