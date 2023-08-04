import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/search_controller.dart';
import 'package:infoctess_koneqt/models/model_type_enum.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  late ModelType filter;
  String searchText = "";
  final tabLabels = ["Posts", "News", "Events", "People"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    searchResults = [];
    filter = ModelType.news;
    searchText = "";
    _tabController = TabController(length: tabLabels.length, vsync: this);
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

  ///Check if a values contain the search term
  bool checkValue(String value) {
    return value.contains(searchText.toLowerCase().trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InputControl(
          controller: _searchController,
          showLabel: false,
          isSearch: true,
          radius: 20,
          // showFilter: true,
          hintText: "Search for Posts, Events, News, People, Hashtags, etc..",
          onChanged: (value) async {},
        ),
        toolbarHeight: kToolbarHeight + 40.w,
      ),
      body: Container(
        child: searchText.isEmpty
            ? buildSearchHistory()
            : Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        switch (index) {
                          case 0:
                            filter = ModelType.post;
                            break;
                          case 1:
                            filter = ModelType.news;
                            break;
                          case 2:
                            filter = ModelType.event;
                            break;
                          case 3:
                            filter = ModelType.people;
                            break;
                          default:
                            filter = ModelType.post;
                            break;
                        }
                      });
                      print(filter.name);
                    },
                    tabs: tabLabels
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList(),
                    controller: _tabController,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildSearchResults(searchText, ModelType.post),
                        buildSearchResults(searchText, ModelType.news),
                        buildSearchResults(searchText, ModelType.event),
                        buildSearchResults(searchText, ModelType.people),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildSearchHistory() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
          decoration: BoxDecoration(color: cSec.withOpacity(0.03)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent searches"),
              TextButton(
                onPressed: () async {
                  await clearHistory().then((value) => setState(() => {}));
                },
                child: const Text("Clear"),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<String>?>(
            future: getSearchHistory(),
            builder: (context, snapshot) {
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
                      leading: const Icon(Icons.history),
                      onTap: () {
                        _searchController.text = snapshot.data![index];
                      },
                      trailing: const Icon(CupertinoIcons.arrow_up_left),
                    );
                  },
                );
              }
              return Center(
                child: Image.asset(
                  "assets/images/preload.gif",
                  width: 30.w,
                  height: 30.w,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  buildSearchResults(String searchText, ModelType filter) {
    // print(filter.name);
    if (searchText.length < 2) {
      return const Center(
        child: Text(
          "Search term must be at least 2 characters",
        ),
      );
    }
    return StreamBuilder(
        stream: setStream(filter),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const EmptyList(
              text: "Something went wrong",
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Image.asset(
                "assets/images/preload.gif",
                width: 30.w,
                height: 30.w,
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const EmptyList(
              text: "No search results",
            );
          }
          if (!snapshot.hasData) {
            return const EmptyList(
              text: "No search results",
            );
          }

          searchResults = snapshot.data!.docs.map((e) => e.data()).toList();
          if (filter == ModelType.post) {
            searchResults = searchResults
                .where((element) =>
                    (element['body'].toString().toLowerCase().contains(
                          searchText.toLowerCase().trim(),
                        )))
                .toList();
          } else if (filter == ModelType.people) {
            searchResults = searchResults
                .where((element) =>
                    (element['fullName']).toString().toLowerCase().contains(
                          searchText.toLowerCase().trim(),
                        ))
                .toList();
          } else {
            searchResults = searchResults
                .where((element) =>
                    (element['title']).toString().toLowerCase().contains(
                          searchText.toLowerCase().trim(),
                        ))
                .toList();
          }
          if (searchResults.isEmpty) {
            return EmptyList(
              text: "No results found for '$searchText'",
            );
          }

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              print(searchResults[index]);
              if (filter == ModelType.post) {
                return ListTile(
                  leading: searchResults[index]['image'] != null
                      ? CachedNetworkImage(
                          height: 50.w,
                          width: 50.w,
                          imageUrl: searchResults[index]['image'],
                        )
                      : null,
                  title: Text(
                    searchResults[index]['body'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    addToHistory(searchText: searchText);
                  },
                  trailing: const Icon(Icons.keyboard_arrow_right),
                );
              } else if (filter == ModelType.people) {
                return ListTile(
                  title: Text(
                    searchResults[index]['fullName'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: searchResults[index]['avatar'] != null
                      ? CircleAvatar(
                          // radius: 20.w,
                          backgroundImage: CachedNetworkImageProvider(
                            searchResults[index]['avatar'],
                          ),
                        )
                      : const Icon(Icons.person),
                  onTap: () {
                    addToHistory(searchText: searchText);
                  },
                );
              } else {
                return ListTile(
                  leading: searchResults[index]['imgUrl'] != null
                      ? CachedNetworkImage(
                          height: 50.w,
                          width: 50.w,
                          imageUrl: searchResults[index]['imgUrl'],
                        )
                      : null,
                  title: Text(
                    searchResults[index]['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    addToHistory(searchText: searchText);
                  },
                );
              }
            },
          );
        });
  }
}
