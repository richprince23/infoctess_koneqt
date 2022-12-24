import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class NewsItem extends StatefulWidget {
  const NewsItem({super.key});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("tapped");
        showModalBottomSheet(
            context: context, builder: (context) => CommentInput());
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Material(
          color: AppTheme.themeData(false, context).primaryColor,
          elevation: 0.5,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
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
                RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  text: TextSpan(
                    text:
                        "There is going to be a General Infoctess Meeting next month when scholl reopens. It is scheduled",
                    style: GoogleFonts.sarabun(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: AppTheme.themeData(false, context).focusColor,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Uptown"),
                    Text("December 11, 2022, 11:34pm"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
