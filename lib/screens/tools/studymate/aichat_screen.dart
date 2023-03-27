import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/ai_controller.dart';
import 'package:infoctess_koneqt/widgets/chat_bubble.dart';

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
    messages.add(ChatItem(
      isUser: false,
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
            child: Text('Clear Chat'),
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
                messages.add(ChatItem(
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
      body: SingleChildScrollView(
        // controller: scrollController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.83,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return messages[index];
            },
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        backgroundColor: Colors.black87,
        enableDrag: false,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InputControl(
                  hintText: "Type your prompt here...",
                  showLabel: false,
                  controller: inputController,
                  focusNode: focusNode,
                ),
              ),
              IconButton(
                onPressed: () async {
                  sendMessage();
                },
                icon: const Icon(Icons.send),
                color: Colors.white,
                // padding: const EdgeInsets.all(8),
                iconSize: 28,
              ),
            ],
          ),
        ),
        onClosing: () {},
      ),
    );
  }

  void sendMessage() async {
    prompt = inputController.text.trim();
    setState(() {
      messages.add(ChatItem(
        isUser: true,
        message: inputController.text,
      ));
    });
    focusNode.unfocus();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        // backgroundColor: Colors.black.withOpacity(0.2),
        // title: const Text('Processing....'),
        content: SizedBox(
          height: 60,
          width: 100,
          child: Center(
            child: Image.asset("assets/images/preload.gif", height: 40),
          ),
        ),
      ),
    );

    await getCompletions(prompt).then((value) {
      inputController.clear();
      setState(() {
        messages.add(ChatItem(
          isUser: false,
          message: value,
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
