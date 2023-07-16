import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/ai_controller.dart';
import 'package:infoctess_koneqt/controllers/chat_controller.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:resize/resize.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => AIChatScreenState();
}

class AIChatScreenState extends State<AIChatScreen> {
  List messages = [];
  FocusNode focusNode = FocusNode();
  final TextEditingController inputController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String prompt = '';

  @override
  void initState() {
    messages.add(ChatBubble(
      hasOptions: false,
      isUser: false,
      showAvatar: false,
      message: "Hi! I'm AI StudyMate. Ask me anything! 😊",
    ));
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Scroll to the end of the list after the widgets are built
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
    // });
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Widget OptionButton(String text, IconData icon, Function() onPressed) {
  Widget optionButton() {
    return PopupMenuButton<String>(
      onSelected: (String choice) {
        // Handle menu item selection
        switch (choice) {
          case 'new':
            // Do something
            break;
          case 'clear':
            // Do something
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        // Define menu items
        return [
          const PopupMenuItem<String>(
            value: 'new',
            child: Text('New Chat'),
          ),
          const PopupMenuItem<String>(
            value: 'clear',
            child: Text('Clear'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[600],
      // backgroundColor: Colors.white,

      appBar: AppBar(
        // backgroundColor: Colors.grey[600],
        title: const Text('AI StudyMate'),
        // foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // optionButton(),
          TextButton.icon(
            onPressed: () {
              setState(() {
                messages.clear();
                messages.add(ChatBubble(
                  hasOptions: false,
                  showAvatar: false,
                  isUser: false,
                  message: "Hi! I'm AI StudyMate. Ask me anything! 😊",
                ));
              });
            },
            icon: const Icon(Icons.delete),
            label: const Text('Clear Chat'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
      body: KeyboardDismissOnTap(
        // controller: scrollController,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  color: cSec.withOpacity(0.05),
                  // ignore: unnecessary_null_comparison
                  image: context.watch<ChatProvider>().chatBackground != ""
                      ? DecorationImage(
                          opacity: 0.8,
                          image: Image.file(
                            File(context.watch<ChatProvider>().chatBackground),
                          ).image,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: ListView.builder(
                  cacheExtent: 50.vh,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InputControl(
                      hintText: "Type your prompt here...",
                      showLabel: false,
                      controller: inputController,
                      isCollapsed: true,
                      focusNode: focusNode,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                    color: cPri,
                    // padding: const EdgeInsets.all(8),
                    iconSize: 28,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    prompt = inputController.text.trim();
    setState(() {
      messages.add(ChatBubble(
        hasOptions: false,
        isUser: true,
        message: inputController.text,
      ));
    });
    focusNode.unfocus();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Image.asset(
          "assets/images/preload.gif",
          height: 40.w,
          width: 40.w,
        ),
      ),
    );

    await getCompletions(prompt).then((value) {
      inputController.clear();
      setState(() {
        messages.add(ChatBubble(
          isUser: false,
          message: value,
          showAvatar: false,
          hasOptions: false,
        ));
      });
    }).whenComplete(() {
      Navigator.of(context).pop();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 500,
        // double.infinity,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );
    });
  }
}
