import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/components/comment_item.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetails extends StatelessWidget {
  PostDetails({Key? key}) : super(key: key);
  ScrollController listScroll = ScrollController();
  ScrollController pageScroll = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Angie\'s Post'),
      ),
      body: CustomScrollView(
        controller: pageScroll,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 0.5,
                shadowColor: Colors.grey,
                color: AppTheme.themeData(false, context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        // height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: CircleAvatar(
                                // radius: 25,
                                child: ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    width: 120,
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1586523969132-b57cf9a85a70?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Angelina Abena Darling Afriyie",
                                  style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text("December 12, 2022 8:56pm",
                                    style: GoogleFonts.sarabun(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Container(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          text: WidgetSpan(
                            child: DetectableText(
                              text:
                                  "Do the best you can, and leave the rest to God; https://bukyia.com  but also, be faithful to your loved ones sglgh dklgd fgdfghd dfhgkdjfhgdkj",
                              detectionRegExp: detectionRegExp()!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              basicStyle: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppTheme.themeData(false, context)
                                      .primaryColorLight),
                              callback: (bool readMore) {
                                debugPrint('Read more >>>>>>> $readMore');
                              },
                              onTap: (tappedText) async {
                                if (tappedText.startsWith('#')) {
                                  print('DetectableText >>>>>>> #');
                                } else if (tappedText.startsWith('@')) {
                                  print('DetectableText >>>>>>> @');
                                } else if (tappedText.startsWith('http')) {
                                  print('DetectableText >>>>>>> http');
                                  Uri url = Uri.parse(tappedText);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $tappedText';
                                  }
                                } else {
                                  print("Post Details");
                                }
                              },
                              alwaysDetectTap: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "153 likes",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight),
                          ),
                          Text(
                            "77 comments",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight),
                          ),
                          Text(
                            "23 shares",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight),
                          ),
                        ],
                      ),
                      Divider(
                        color: AppTheme.themeData(false, context).focusColor,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.heart,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight,
                              size: 18,
                            ),
                            label: Text(
                              "like",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.themeData(false, context)
                                      .primaryColorLight),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              scaffoldKey.currentState!
                                  .showBottomSheet((context) => CommentInput());
                            },
                            icon: Icon(
                              CupertinoIcons.chat_bubble,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight,
                              size: 18,
                            ),
                            label: Text(
                              "comment",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.share,
                              color: AppTheme.themeData(false, context)
                                  .primaryColorLight,
                              size: 18,
                            ),
                            label: Text(
                              "share",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.themeData(false, context)
                                    .primaryColorLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            fillOverscroll: false,
            hasScrollBody: true,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                // controller: listScroll,
                itemCount: 10,
                itemBuilder: ((context, index) {
                  return CommentItem();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
