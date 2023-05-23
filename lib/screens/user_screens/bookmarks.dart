import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/components/news_item.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/models/bookmarks_model.dart';
import 'package:infoctess_koneqt/models/news_model.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.w),
        color: cSec.withOpacity(0.05),
        child: FutureBuilder<List<Bookmark>>(
          future: AppDatabase.instance.getAllBookmarks(),
          builder: (context, AsyncSnapshot<List<Bookmark>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset("assets/images/preload.gif"),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: EmptyList(
                  text:
                      'You have not saved any item yet.\nTap the bookmark icon on any item to see it here.',
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    direction: Axis.horizontal,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 1,
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) async {
                            CustomDialog.showWithAction(context,
                                message: "Delete this note?",
                                title: "Delete", action: () async {
                              await AppDatabase.instance
                                  .deleteBookmark(snapshot.data![index].ref)
                                  .then((value) {
                                    setState(() {
                                      snapshot.data!.removeAt(index);
                                    });
                                  })
                                  .then((value) => Navigator.pop(context))
                                  .then(
                                    (value) => StatusAlert.show(
                                      context,
                                      duration: const Duration(seconds: 2),
                                      title: "Bookmark deleted successfully",
                                      titleOptions:
                                          StatusAlertTextConfiguration(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp + 1,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      maxWidth: 50.vw,
                                      configuration: IconConfiguration(
                                        icon: Icons.check,
                                        color: Colors.green,
                                        size: 50.w,
                                      ),
                                    ),
                                  );
                            });
                          },
                          backgroundColor: Colors.red.shade300,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) {},
                          backgroundColor: Colors.blue.shade300,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      surfaceTintColor: Colors.white.withOpacity(0.5),
                      color: Colors.white,
                      child: ListTile(
                        textColor: Colors.black,
                        contentPadding: EdgeInsets.all(10.w),
                        leading: Icon(
                          Icons.event,
                          color: cPri,
                        ),
                        // tileColor: Colors.white.withOpacity(0.5),
                        title: Text(
                          snapshot.data![index].title,
                          style: TextStyle(fontSize: 16.sp + 1),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        subtitle: Text(snapshot.data![index].createdAt!),
                        trailing: Text(snapshot.data![index].category.name),
                        onTap: () async {
                          if (snapshot.data![index].category.name == 'news') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindNewsItem(
                                  newsID: snapshot.data![index].ref,
                                ),
                              ),
                            );
                          }
                          // ).then((value) {});
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
