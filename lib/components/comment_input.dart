import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

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
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.themeData(false, context).dialogBackgroundColor),
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
                  iconSize: 16),
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
                              color: AppTheme.themeData(false, context)
                                  .focusColor),
                        ),
                        focusColor:
                            AppTheme.themeData(false, context).focusColor),
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
                            child: Text("${commentText.text.length}/ 250")),
                        TextButton(
                          onPressed: (() {
                            isEmtpyText ? null : print("sent");
                            Navigator.pop(context);
                          }),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            fixedSize: const Size(60, 30),
                            alignment: Alignment.center,
                            backgroundColor: !isEmtpyText
                                ? AppTheme.themeData(false, context)
                                    .backgroundColor
                                : Colors.transparent,
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
    );
  }
}
