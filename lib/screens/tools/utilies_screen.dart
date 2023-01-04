import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/appbar.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.blue,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.blue, Colors.pink],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Card(
              surfaceTintColor: Colors.white,
              color: AppTheme.themeData(false, context).cardColor,
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(CupertinoIcons.money_dollar,
                        size: 50,
                        color: AppTheme.themeData(false, context)
                            .primaryColorLight),
                    Text(
                      "My Dues",
                      style: GoogleFonts.sarabun(
                          color: AppTheme.themeData(false, context)
                              .primaryColorLight,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Card(),
            Card(),
            Card(),
            Card(),
            Card(),
          ],
        ),
      ),
    );
  }
}
