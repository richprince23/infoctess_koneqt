import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/components/comment_input.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class EventItem extends StatefulWidget {
  const EventItem({super.key});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("tapped");
      },
      child: OpenContainer(
        closedBuilder: (context, action) => ClosedEventItem(),
        openBuilder: (context, action) => OpenEventItem(),
      ),
    );
  }
}

class ClosedEventItem extends StatelessWidget {
  const ClosedEventItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Card(
        color: AppTheme.themeData(false, context).primaryColor,
        elevation: 2,
        surfaceTintColor: Colors.white,
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
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed eu",
                  style: GoogleFonts.sarabun(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
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
    );
  }
}

class OpenEventItem extends StatelessWidget {
  const OpenEventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Material(
        elevation: 2,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 110),
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
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
                      color:
                          AppTheme.themeData(false, context).primaryColorLight),
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
                  text: TextSpan(
                    text:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc.                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. Sed euismod, nunc ut aliquam ultricies, nunc nisl aliquam nunc, eget aliquam nunc nisl euismod nunc. ",
                    style:
                        GoogleFonts.sarabun(color: Colors.black, fontSize: 16),
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
                    Text("President"),
                    Text("December 11, 2022, 11:34pm"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text("Date: "),
                  Expanded(
                      child: Text(
                    "December 11, 2022, 11:34pm",
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text("Venue: "),
                  Expanded(
                    child: Text(
                      "1234 Main Street, New York, NY 10001 sdfhjksdhfjkshdjfhsjkdhfjsdhfjksdhfjk",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(CupertinoIcons.bell_fill),
                  onPressed: () {
                    print("Reminded!");
                  },
                  label: const Text("Notify"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        AppTheme.themeData(false, context).backgroundColor,
                    foregroundColor:
                        AppTheme.themeData(false, context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // fixedSize: const Size(134, 30),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(CupertinoIcons.bookmark_fill),
                  onPressed: () {},
                  label: const Text("Save"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        AppTheme.themeData(false, context).backgroundColor,
                    foregroundColor:
                        AppTheme.themeData(false, context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // fixedSize: const Size(134, 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
