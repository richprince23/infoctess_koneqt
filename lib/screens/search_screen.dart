import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/controllers/search_controller.dart';
import 'package:infoctess_koneqt/models/model_type_enum.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  late ModelType filter;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchResults = [];
    filter = ModelType.news;
    searchText = "";
    //listen to changes in search controller
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        setState(() {
          searchResults.clear();
          searchText = _searchController.text.trim().toLowerCase();
        });
      } else {
        setState(() {
          searchResults.clear();
          searchText = "";
        });
      }
    });
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
                  // if (value.isEmpty || value == "" || value.length < 3) {
                  //   return;
                  // }
                  // setState(() {
                  //   searchResults = [];
                  // });

                  // await search(value).then((value) => setState(() {
                  //       print(value);
                  //       searchResults.addAll(value);
                  //     }));
                },
              ),
            ),
            IconButton(
              onPressed: () {
                print("how filter lists");
              },
              icon: const Icon(Icons.filter_list),
            )
          ],
        ),
        toolbarHeight: kToolbarHeight + 40.w,
      ),
      body: Container(
          child: StreamBuilder(
        stream: setStream(filter),
        // initialData: searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Image.asset(
                "assets/images/preload.gif",
                width: 30.w,
                height: 30.w,
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.size,
              itemBuilder: (context, index) {
                if (snapshot.data?.docs[index]['body']
                    .contains(searchText.toLowerCase().trim())) {
                  return ListTile(
                    title: Text(snapshot.data?.docs[index]['title']),
                    // onTap: () {
                    //   _searchController.text = snapshot.data![index];
                    // },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }
          return const Center(
            child: EmptyList(),
          );
        },
      )),
    );
  }

  Widget buildSearchHistory() {
    return FutureBuilder<List<String>?>(
      future: getSearchHistory(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const EmptyList(
              text: "No search history",
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () {
                  _searchController.text = snapshot.data![index];
                },
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
