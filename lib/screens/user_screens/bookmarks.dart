import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

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
        child: FutureBuilder(
          future: AppDatabase.instance.getAllBookmarks(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset('assets/images/preload.gif',
                    height: 30.w, width: 30.w),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].category.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // delete bookmark
                        },
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: EmptyList(
                text:
                    'You have not saved any item yet.\nTap the bookmark icon on any item to see it here.',
              ),
            );
          }),
        ),
      ),
    );
  }
}
