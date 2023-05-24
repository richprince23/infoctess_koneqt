import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/models/comments_model.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  const CommentItem({super.key, required this.comment});


  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                print("profile tapped");
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                // height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                          style:
                              GoogleFonts.sarabun(fontWeight: FontWeight.w500),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DetectableText(
                detectionRegExp: detectionRegExp()!,
                text:
                    comment.text,
              ),
            )
          ],
        ),
      ),
    );
  }
}
