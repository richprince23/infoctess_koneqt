import 'dart:io';

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

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  late ModelType filter;
  String searchText = "";
  final tabLabels = ["Posts", "News", "Events", "People"];

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
            : StreamBuilder(
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
                        if (checkValue(snapshot.data?.docs[index]['body']) ||
                            checkValue(snapshot.data?.docs[index]['title'])) {
                          return ListTile(
                            title: Text(snapshot.data?.docs[index]['title']),
                            onTap: () {
                              addToHistory(searchText: searchText);
                            },
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
                onPressed: () async {},
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

  void showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return Platform.isAndroid
              ? AlertDialog(
                  title: const Text("Filter Search"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("All"),
                        onTap: () {
                          setState(() {
                            filter = ModelType.all;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("Posts"),
                        onTap: () {
                          setState(() {
                            filter = ModelType.post;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("News"),
                        onTap: () {
                          setState(() {
                            filter = ModelType.event;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("Events"),
                        onTap: () {
                          setState(() {
                            filter = ModelType.event;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("People"),
                        onTap: () {
                          setState(() {
                            filter = ModelType.people;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              : CupertinoAlertDialog(
                  title: const Text("Filter Search"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoListTile(
                          title: const Text("All"),
                          onTap: () {
                            setState(() {
                              filter = ModelType.all;
                            });
                            Navigator.pop(context);
                          }),
                      CupertinoListTile(
                          title: const Text("Posts"),
                          onTap: () {
                            setState(() {
                              filter = ModelType.post;
                            });
                            Navigator.pop(context);
                          }),
                      CupertinoListTile(
                          title: const Text("News"),
                          onTap: () {
                            setState(() {
                              filter = ModelType.news;
                            });
                            Navigator.pop(context);
                          }),
                      CupertinoListTile(
                          title: const Text("Events"),
                          onTap: () {
                            setState(() {
                              filter = ModelType.event;
                            });
                            Navigator.pop(context);
                          }),
                      CupertinoListTile(
                          title: const Text("People"),
                          onTap: () {
                            setState(() {
                              filter = ModelType.people;
                            });
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                );
        });
  }
}
