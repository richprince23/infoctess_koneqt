import 'package:animations/animations.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: OpenContainer(
        transitionDuration: const Duration(seconds: 1),
        closedColor: Colors.transparent,
        // AppTheme.themeData(false, context).primaryColor.withOpacity(0.5),
        useRootNavigator: true,
        openElevation: 5,
        transitionType: ContainerTransitionType.fadeThrough,
        closedBuilder: (BuildContext context, void Function() openAction) {
          return const ClosedWidget();
        },
        openBuilder: (BuildContext context, void Function() action) {
          return const OpenWidget();
        },
      ),
    );
  }
}

class ClosedWidget extends StatelessWidget {
  const ClosedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: AppTheme.themeData(false, context).primaryColor.withOpacity(0.7),
        surfaceTintColor: Colors.white,
        elevation: 2,
        // borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Infoctess General Meeting",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        AppTheme.themeData(false, context).primaryColorLight),
                textAlign: TextAlign.left,
              ),
              Divider(
                color: AppTheme.themeData(false, context).focusColor,
                thickness: 1,
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color:
                        AppTheme.themeData(false, context).primaryColorLight),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Uptown"),
                      Text("December 11, 2022, 11:34pm"),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: const Text("Read More"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenWidget extends StatelessWidget {
  const OpenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    child: Image.asset(
                      "assets/images/img1.jpg",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Infoctess General Meeting",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: AppTheme.themeData(false, context).focusColor,
                    thickness: 1,
                  ),
                  RichText(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                    text: WidgetSpan(
                      child: DetectableText(
                        detectionRegExp: detectionRegExp()!,
                        text:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed eu",
                        basicStyle: GoogleFonts.sarabun(
                            color: Colors.black, fontSize: 16),
                        moreStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        lessStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: (tappedText) async {
                          if (tappedText.startsWith('#')) {
                            print('DetectableText >>>>>>> #');
                          } else if (tappedText.startsWith('@')) {
                            print('DetectableText >>>>>>> @');
                          } else if (tappedText.startsWith('http')) {
                            print('DetectableText >>>>>>> http');
                            // final link = await LinkPreviewer.getPreview(tappedText);
                            Uri url = Uri.parse(tappedText);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $tappedText';
                            }
                          } else {
                            print("nothing");
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Divider(
                      color: AppTheme.themeData(false, context).focusColor,
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Uptown"),
                      Text("December 11, 2022, 11:34pm"),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
