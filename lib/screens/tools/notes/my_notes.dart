import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:infoctess_koneqt/screens/tools/notes/read_note.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

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
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          // color: constants.color,
          strokeWidth: 2,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppTheme.themeData(false, context).backgroundColor,
                ))
              : buildNotes(),
          onRefresh: () async {
            setState(() {
              buildNotes();
            });
          },
        ),
      ),
    );
  }

  Widget buildNotes() {
    return FutureBuilder(
      future: AppDatabase.instance.getNotes(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(5),
                // onLongPress: ,
                leading: IconButton(
                  onPressed: () async {
                    //delete note here
                    showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            content: const Text("Delete this note?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AppDatabase.instance
                                      .deleteNote(snapshot.data[index].id)
                                      .then((value) {
                                    setState(() {
                                      snapshot.data!.removeAt(index);
                                    });
                                  }).then((value) => Navigator.pop(context));
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          )),
                    );
                    // await AppDatabase.instance
                    //     .deleteNote(snapshot.data[index].id)
                    //     .then((value) {
                    //   setState(() {
                    //     snapshot.data!.removeAt(index);
                    //   });
                    // });
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
                tileColor: Colors.white,
                title: Text(snapshot.data[index].title),
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
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
        // return const Center(child: Text("No Notes added"));
      },
    );
  }
}
