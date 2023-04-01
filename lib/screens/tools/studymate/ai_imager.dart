import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/ai_controller.dart';
import 'package:infoctess_koneqt/screens/tools/image_viewer.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';

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
    return Scaffold(
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
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: isDone == true
                ? SizedBox(
                    height: 80,
                    child: ChatItem(isUser: true, message: prompt),
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
              backgroundColor:
                  AppTheme.themeData(false, context).backgroundColor,
              foregroundColor: AppTheme.themeData(false, context).primaryColor,
              fixedSize: const Size(200, 50),
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
                    await sendPrompt().then((value) => textFocusNode.unfocus());
                    // Navigator.of(context, rootNavigator: true).pop();
                  },
            child: const Text('Generate Images'),
          ),
          const SizedBox(height: 10),
        ],
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
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: Image.asset(
              "assets/images/preload.gif",
              height: 50,
            ),
          ),
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
      Platform.isAndroid
          ? showDialog(
              useRootNavigator: true,
              barrierDismissible: false,
              context: context,
              builder: (context) => const CustomDialog(
                  message: "An error occurred when performing your request"))
          : showCupertinoDialog(
              context: context,
              builder: (context) => const CustomDialog(
                  message: "An error occurred when performing your request"));
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: Image.asset("assets/images/preload.gif",
                                height: 50),
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
