import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/post_controller.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class CommentInput extends StatefulWidget {
  final String postID;
  const CommentInput({super.key, required this.postID});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final textKey = GlobalKey<FormFieldState>();
  final commentText = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isEmtpyText = true;
  // final scroll = ScrollController();
  @override
  void dispose() {
    commentText.dispose();
    focusNode.dispose();
    textKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black45,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: IconButton(
                  style: IconButton.styleFrom(
                      fixedSize: const Size(20, 20),
                      padding: const EdgeInsets.all(5)),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(CupertinoIcons.clear),
                  iconSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    DetectableTextField(
                      detectionRegExp: detectionRegExp(
                          atSign: true, hashtag: true, url: true)!,
                      onChanged: ((value) {
                        commentText.text.isEmpty
                            ? isEmtpyText = true
                            : isEmtpyText = false;
                        setState(() {});
                      }),
                      key: textKey,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      keyboardType: TextInputType.multiline,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(120),
                      ],
                      controller: commentText,
                      minLines: 1,
                      maxLines: 4,
                      focusNode: focusNode,
                      // autofocus: true,
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: cSec,
                          ),
                        ),
                        focusColor: cSec,
                      ),
                      basicStyle: GoogleFonts.sarabun(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                fixedSize: const Size(20, 20)),
                            onPressed: () => focusNode.hasFocus
                                ? FocusScope.of(context).unfocus()
                                : FocusScope.of(context).requestFocus(),
                            icon: const Icon(CupertinoIcons.keyboard),
                            iconSize: 18,
                          ),
                          Expanded(
                            child:
                                Text("${commentText.text.runes.length}/ 256"),
                          ),
                          TextButton(
                            onPressed: (() async {
                              isEmtpyText
                                  ? null
                                  : await sendComment(
                                          commentText.text, widget.postID)
                                      .then(
                                        (value) => Provider.of<Stats>(context,
                                                listen: false)
                                            .getStats(widget.postID),
                                      )
                                      .then(
                                        (value) => StatusAlert.show(
                                          context,
                                          backgroundColor: Colors.transparent,
                                          title: "Sent",
                                          configuration: IconConfiguration(
                                            icon: Icons.check,
                                            color: Colors.green,
                                            size: 50.w,
                                          ),
                                          maxWidth: 50.vw,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      )
                                      .then(
                                        (value) => Navigator.pop(context),
                                      );
                            }),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              fixedSize: const Size(60, 30),
                              alignment: Alignment.center,
                              backgroundColor:
                                  !isEmtpyText ? cPri : Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("reply"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
