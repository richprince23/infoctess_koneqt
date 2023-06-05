import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:infoctess_koneqt/screens/tools/notes/read_note.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({Key? key}) : super(key: key);
  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> with RouteAware {
  late List<Note> notes;
  bool isLoading = false;
  //get all notes
  Future getNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await AppDatabase.instance.getNotes();

    setState(() {
      isLoading = false;
    });
  }

//get one note
  Future getNote(int id) async {
    setState(() {
      isLoading = true;
    });

    await AppDatabase.instance.getNote(id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'My Notes',
          // style: TextStyle(),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.popAndPushNamed(context, '/add-note');
              Navigator.pushNamed(context, '/add-note');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: cSec,
        strokeWidth: 3,
        displacement: 10,
        child: isLoading
            ? Center(
                child: Image.asset(
                  'assets/images/preload.gif',
                  height: 20.h,
                  width: 20.h,
                ),
              )
            : Container(
                // decoration: const BoxDecoration(
                //   // color: Colors.blue,
                //   gradient: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: [Colors.blue, Colors.pink],
                //     stops: [0.2, 1],
                //   ),
                // ),
                color: cSec.withOpacity(0.1),
                padding: const EdgeInsets.all(10),
                child: buildNotes(),
              ),
        onRefresh: () async {
          setState(() {
            buildNotes();
          });
        },
      ),
    );
  }

  Widget buildNotes() {
    return FutureBuilder(
      future: AppDatabase.instance.getNotes(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null ||
            snapshot.data.length == 0 ||
            snapshot.data == [] ||
            snapshot.data!.isEmpty) {
          return EmptyList(
            text:
                "You don't seem to have any notes yet🤔\n Click the + button to add a new note",
          );
        }

        if (snapshot.hasData) {
          return ListView.builder(
            cacheExtent: 50.vh,
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
                              .deleteNote(snapshot.data[index].id)
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
                                  title: "Note deleted successfully",
                                  titleOptions: StatusAlertTextConfiguration(
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  surfaceTintColor: Colors.white.withOpacity(0.5),
                  color: AppTheme.themeData(false, context)
                      .cardColor
                      .withOpacity(0.5),
                  child: ListTile(
                    textColor:
                        AppTheme.themeData(false, context).primaryColorLight,
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Icon(
                      CupertinoIcons.pencil_outline,
                    ),
                    // tileColor: Colors.white.withOpacity(0.5),
                    title: Text(
                      snapshot.data[index].title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(snapshot.data[index].createdAt),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadNoteScreen(
                              noteID: snapshot.data[index].id!,
                              title: snapshot.data[index].title.toString(),
                              content: snapshot.data[index].content.toString()),
                        ),
                      ).then((value) {});
                    },
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: Image.asset(
            "assets/images/preload.gif",
            height: 30.w,
            width: 30.w,
          ),
        );
        // return const Center(child: Text("No Notes added"));
      },
    );
  }
}
