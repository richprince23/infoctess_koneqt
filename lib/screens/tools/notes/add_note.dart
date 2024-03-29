import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/constants.dart';
// import 'package:infoctess_koneqt/db_helper.dart';
import 'package:infoctess_koneqt/models/notes_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
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
  bool showSave = false;
  //save note to db
  Future addNote(BuildContext context) async {
    var json = jsonEncode(_content.toJson());

    var nowDate = DateFormat.yMEd().add_jms().format(DateTime.now()).toString();
    if (_title.text.isNotEmpty && !_quillController.document.isEmpty()) {
      Note note = Note(title: _title.text, content: json, createdAt: nowDate);

      AppDatabase.instance.addNote(note).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Note Saved Successfully!",
              textAlign: TextAlign.center),
          backgroundColor: cPri,
        ));
        setState(() {
          AppDatabase.instance.getNotes();
        });
        // Navigator.popAndPushNamed(context, '/notes');
        Navigator.pop(context);
      });
    } else {
      CustomSnackBar.show(context,
          message: "Note title and content cannot be empty!");
    }
  }

  @override
  void initState() {
    super.initState();
    _title.addListener(() {
      setState(() {
        _title.text.isNotEmpty ? showSave = true : showSave = false;
      });
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // bool isWide = width > 280;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Note',
        ),
        // backgroundColor: Colors.white.withOpacity(0.5),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft])
                    : SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]),
            tooltip: "Rotate Screen",
            icon: const Icon(Icons.rotate_left),
          ),
          showSave
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    addNote(context).then(
                      (value) => AppDatabase.instance.getNotes().then(
                            (value) =>
                                Navigator.popAndPushNamed(context, '/my-notes'),
                          ),
                    );
                  },
                )
              : const SizedBox.shrink(),
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
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      labelText: 'Note Title',
                      fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.themeData(false, context).focusColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.themeData(false, context)
                              .focusColor
                              .withOpacity(0.8),
                          width: 0.5,
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    return QuillToolbar.basic(
                      multiRowsDisplay: false,
                      iconTheme: const QuillIconTheme(
                          iconUnselectedColor: Colors.black87
                          // AppTheme.themeData(false, context).backgroundColor,
                          ),
                      controller: _quillController,
                      showAlignmentButtons: false,
                      // showCameraButton: false,
                      showCodeBlock: false,
                      showColorButton: true,
                      showClearFormat: true,
                      showBackgroundColorButton: false,
                      showHeaderStyle: false,
                      showLink: false,
                      showQuote: false,
                      showDividers: true,
                      // showImageButton: false,
                      // showVideoButton: false,
                      showInlineCode: false,
                    );
                  },
                ),
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
                    controller: _quillController,
                    readOnly: false,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
