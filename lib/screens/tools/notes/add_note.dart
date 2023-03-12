import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
// import 'package:infoctess_koneqt/db_helper.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:intl/intl.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _title = TextEditingController();
  late final _content = _quillController.document.toDelta();

  final QuillController _quillController = QuillController.basic();

  //save note to db
  Future addNote(BuildContext context) async {
    var json = jsonEncode(_content.toJson());

    var nowDate = DateFormat.yMEd().add_jms().format(DateTime.now()).toString();
    if (_title.text.isNotEmpty && !_quillController.document.isEmpty()) {
      Note note = Note(title: _title.text, content: json, createdAt: nowDate);

      AppDatabase.instance.addNote(note).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Note Saved \nPull down to refresh!"),
          backgroundColor: Color.fromRGBO(117, 64, 237, 1),
        ));
        setState(() {
          AppDatabase.instance.getNotes();
        });
        // Navigator.popAndPushNamed(context, '/notes');
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isWide = width > 300;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add New Note',
            // style: TextStyle(
            //   color: Colors.white,
            // ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              // color: Colors.white,
              onPressed: () {
                addNote(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Title',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: isWide
                      ? QuillToolbar.basic(
                          iconTheme: QuillIconTheme(
                            iconUnselectedColor:
                                AppTheme.themeData(false, context)
                                    .backgroundColor,
                          ),
                          controller: _quillController,
                          showAlignmentButtons: false,
                          // showCameraButton: false,
                          showCodeBlock: false,
                          showColorButton: false,
                          showHeaderStyle: false,
                          showLink: false,
                          showQuote: false,
                          showDividers: true,
                          // showImageButton: false,
                          // showVideoButton: false,

                          showInlineCode: false,
                        )
                      : null,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppTheme.themeData(false, context).primaryColor,
                      ),
                    ),
                    child: QuillEditor.basic(
                        controller: _quillController, readOnly: false),
                  ),
                ),
              ]),
        ));
  }
}
