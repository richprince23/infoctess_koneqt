import 'package:animations/animations.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 200),
        closedColor: Colors.white70,
        // AppTheme.themeData(false, context).primaryColor.withOpacity(0.5),
        useRootNavigator: true,
        openElevation: 0,
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
      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
      child: Card(
        // color: Colors.white.withOpacity(0.7),
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Container(
          margin: EdgeInsets.all(8.w),
          padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Infoctess General Meeting",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
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
                    fontSize: 16.sp,
                    overflow: TextOverflow.ellipsis,
                    color:
                        AppTheme.themeData(false, context).primaryColorLight),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Uptown",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        "December 11, 2022, 11:34pm",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    child: const Icon(Icons.open_in_new),
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
        title: Text(
          "News Details",
          style: TextStyle(fontSize: 14.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          iconSize: 24.h,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.red,
                    ),
                    child: Image.asset(
                      "assets/images/img1.jpg",
                      height: 200.h,
                      width: 100.vw,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Infoctess General Meeting",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.h),
                  Divider(
                    color: AppTheme.themeData(false, context).focusColor,
                    thickness: 1,
                  ),
                  RichText(
                    selectionColor: Colors.blueAccent,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                    text: WidgetSpan(
                      child: DetectableText(
                        detectionRegExp: detectionRegExp()!,
                        text:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed eu",
                        basicStyle: GoogleFonts.sarabun(
                            color: Colors.black, fontSize: 16.sp),
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
                    padding: EdgeInsets.all(10.w),
                    child: Divider(
                      color: AppTheme.themeData(false, context).focusColor,
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Uptown",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        "December 11, 2022, 11:34pm",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
