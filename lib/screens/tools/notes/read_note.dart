import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class ReadNoteScreen extends StatefulWidget {
  final int noteID;
  final content;
  final title;

  const ReadNoteScreen(
      {Key? key,
      required this.noteID,
      required this.title,
      required this.content})
      : super(key: key);
  @override
  ReadNoteScreenState createState() => ReadNoteScreenState();
}

class ReadNoteScreenState extends State<ReadNoteScreen> {
  // final QuillController _quill = QuillController.basic();
  late var myJSON;
  late QuillController _controller;
  late Note? note;
  bool _edit = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    myJSON = jsonDecode(widget.content!.toString());

    // _controller.document.insert(0, myJSON);
    _controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
    // _quill.document.insert(0, myJSON);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: AppTheme.themeData(false, context).backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(widget.title.toString()),
          actions: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _edit = !_edit;
                  });
                })
          ]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: Text("no note found"))
            : Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: QuillEditor.basic(
                  // controller: _quill,
                  controller: _controller,
                  readOnly: true,
                ),
              ),
      ),
    );
  }
}
