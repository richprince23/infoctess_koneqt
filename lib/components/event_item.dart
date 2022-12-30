import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class EventItem extends StatelessWidget {
  const EventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("tapped");
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
                // Image(
                //     image: CachedNetworkImageProvider(
                //   "file://assets/images/assets1.jpg",
                // )),

                Image.asset("assets/images/img1.jpg"),
                Text(
                  "Infoctess General Meeting",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
                  textAlign: TextAlign.left,
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
