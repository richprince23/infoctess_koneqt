import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class SearchScreen extends StatefulWidget {
  final ModelType modelType;
  const SearchScreen({Key? key, this.modelType = ModelType.all})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List searchResults = [];
  // List searchResults1 = [];

  Future<void> search(String query) async {
    // searchResults.clear();

    final posts = await db
        .collection('posts')
        .where('body', isGreaterThanOrEqualTo: query.toLowerCase())
        .get();

    // final news = await db
    //     .collection('news')
    //     .where('body', isGreaterThanOrEqualTo: query.toLowerCase())
    //     .get();

    // final events = await db
    //     .collection('events')
    //     .where('body', isGreaterThanOrEqualTo: query.toLowerCase())
    //     .get();

    // final users = await db
    //     .collection('user_infos')
    //     .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
    //     .get();
    setState(() {
      searchResults.clear();
    });

    for (var item in posts.docs) {
      print(item.data()['body']);
      setState(() {
        searchResults.add(item.data());
      });
      // searchResults.add(item.data());
    }

    // searchResults
    //     .addAll(posts.docs.map((doc) => doc.data() as Map<String, dynamic>));
    // searchResults
    //     .addAll(news.docs.map((doc) => doc.data() as Map<String, dynamic>));
    // searchResults
    //     .addAll(events.docs.map((doc) => doc.data() as Map<String, dynamic>));
    // print(searchResults.length);
    // print(searchResults[0]['body']);

    // searchResults
    //     .addAll(users.docs.map((doc) => doc.data() as Map<String, dynamic>));
  }

  @override
  void initState() {
    super.initState();
    searchResults = [];
    // search("");
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchResults.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: InputControl(
                controller: _searchController,
                showLabel: false,
                isSearch: true,
                radius: 20,
                // showFilter: true,
                hintText:
                    "Search for Posts, Events, News, People, Hashtags, etc..",
                onChanged: (value) async {
                  setState(() {
                    searchResults.clear();
                  });
                  if (value.isEmpty || value == "" || value.length < 3) {
                    return;
                  }
                  // if (value.length < 3) {
                  //   return;
                  // }
                  showDialog(
                    context: context,
                    builder: (context) => Center(
                      child: Image.asset(
                        "assets/images/preload.gif",
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                  );
                  await search(value).then((value) {
                    setState(() {});
                  }).then(
                    (value) => Navigator.pop(context),
                  );
                  // print(searchResults.length);
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  print("how filter lists");
                },
                icon: const Icon(Icons.filter_list))
          ],
        ),
        toolbarHeight: kToolbarHeight + 40.w,
      ),
      body: Center(
        child: buildSearchList(),
      ),
    );
  }

  Widget buildSearchList() {
    if (searchResults.isNotEmpty) {
      // print(searchResults);
      return ListView.builder(
        cacheExtent: 100.vh,
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final item = searchResults[index];

          // if (item.containsKey('title')) {
          //   return ListTile(
          //     title: Text(
          //       item['title'] as String,
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 2,
          //     ),
          //     leading: Icon(Icons.newspaper),
          //   );
          // } else {
          return ListTile(
            title: Text(
              item['body'] as String,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            leading: const Icon(Icons.textsms),
          );
        },
        // },
      );
    }
    return const Center(
      child: EmptyList(text: "No results found"),
    );
  }
}

/// This enum returns the various types of models that a search can be performed against
///
/// [all] - All models
///
/// [post] - Post items only
///
/// [event] - Event items only
///
/// [news] - News items only
///
enum ModelType {
  all,
  post,
  event,
  news,
}
