import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/ai_controller.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:resize/resize.dart';

class Imager extends StatefulWidget {
  const Imager({super.key});

  @override
  State<Imager> createState() => ImagerState();
}

class ImagerState extends State<Imager> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  // final scrollController = ScrollController();
  bool isTextEmpty = true;
  bool isLoading = false;
  bool isDone = false;
  String prompt = '';
  // String imgURL = '';
  List<String> images = [];

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Imager'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: isDone == false
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: buildImages(images),
                      ),
                    ),
            ),
            SizedBox(height: 10.w),
            Align(
              alignment: Alignment.bottomRight,
              child: isDone == true
                  ? SizedBox(
                      height: 80.w,
                      child: ChatBubble(
                        isUser: true,
                        message: prompt,
                        hasOptions: false,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InputControl(
                controller: textController,
                focusNode: textFocusNode,
                type: TextInputType.multiline,
                hintText: 'Enter prompt here...',
                readOnly: isLoading == true ? true : false,
                showLabel: false,
              ),
            ),
            // const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cPri,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading == true
                  ? () {}
                  : () async {
                      if (textController.text.isEmpty || isLoading == true) {
                        return;
                      }
                      await sendPrompt()
                          .then((value) => textFocusNode.unfocus());
                      // Navigator.of(context, rootNavigator: true).pop();
                    },
              child: const Text('generate images'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> sendPrompt() async {
    prompt = textController.text;
    setState(() {
      isLoading = true;
    });

    showDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Image.asset(
          "assets/images/preload.gif",
          width: 30.w,
          height: 30.w,
        ),
      ),
    );

    try {
      images = await getGenerations(prompt);
      // Navigator.of(context, rootNavigator: true).pop();
      // buildImages(images);
      textController.clear();
    } catch (e) {
      // Display error message in case of an exception

      CustomDialog.show(context,
          message: "An error occurred when performing your request");
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        isLoading = false;
        isDone = true;
      });
      FocusScope.of(context).unfocus();
      textFocusNode.unfocus();
    }
  }

  buildImages(List<String> images) {
    var size = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewer(
                  image: images[index],
                ),
              ),
            );
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: Image.asset(
                              "assets/images/preload.gif",
                              height: 30.w,
                              width: 30.w,
                            ),
                          ),
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(CupertinoIcons.photo, size: 100)),
                images[index],
                height: size.width * 0.30,
                width: size.width * 0.30,
              ),
            ),
          ),
        );
      },
    );
  }
}
