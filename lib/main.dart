import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, child) => Portal(child: child!),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  List<UserProfile> data = [];
  String mentionQuery = "";
  String userText = "";
  List<int> mentionedUserIds = [];
  int count = 1;

  @override
  void initState() {
    super.initState();

    conditionFunction();
  }

  void conditionFunction() {
    if (count == 1) {
      fetchDataWithoutQuery();
    } else {
      fetchDataWithQuery(mentionQuery);
    }
  }

  Future<void> fetchDataWithoutQuery() async {
    const String token =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoyLCJ0aW1lIjoxNzAxOTQ0NjE1fQ.ZCl1pDug6j90L4HqVcCjNMSYF3wRuRac1gy9XPUyXZY';
    final response = await http.get(
      Uri.parse('https://staging.simmpli.com/api/v1/profiles/mentions.json?q='),
      headers: {'Authorization': token},
    );

    print("Response of API: $response");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        data = responseData.map((json) => UserProfile.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataWithQuery(String query) async {
    print('Fetching data for query: $query');
    const String token =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoyLCJ0aW1lIjoxNzAxOTQ0NjE1fQ.ZCl1pDug6j90L4HqVcCjNMSYF3wRuRac1gy9XPUyXZY';
    final response = await http.get(
      Uri.parse('https://staging.simmpli.com/api/v1/profiles/mentions.json?q=$query'),
      headers: {'Authorization': token},
    );

    print("Response of API: $response");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        data = responseData.map((json) => UserProfile.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Get Text'),
              onPressed: () {
                if (kDebugMode) {
                  print(key.currentState!.controller!.markupText);
                  print("Mentioned User IDs: $mentionedUserIds");
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FlutterMentions(
                      key: key,
                      suggestionPosition: SuggestionPosition.Top,
                      maxLines: 5,
                      minLines: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write your comment',
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print(key.currentState!.controller!.markupText);
                              print("Mentioned User IDs: $mentionedUserIds");
                              for (int id in mentionedUserIds) {
                                print("User ID: $id");
                              }
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                      mentions: [
                        Mention(
                          trigger: '@',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          data: data.map((userProfile) => userProfile.toJson()).toList(),
                          matchAll: false,
                          suggestionBuilder: (data) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        "https://staging.simmpli.com/" + data['photo'],
                                      ),
                                      radius: 10,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text('${data['display']}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      onChanged: (text) {
                        setState(() {
                          userText = text;
                        });

                        final query = text.substring(text.lastIndexOf('@') + 1);
                        setState(() {
                          mentionQuery = query;
                        });

                        count++;
                        if (count == 1) {
                          fetchDataWithoutQuery();
                        } else {
                          fetchDataWithQuery(mentionQuery);
                        }

                        // Extract mentioned user IDs from userText using the model
                        List<int> newMentionedUserIds = extractUserIdsFromModel(userText);
                        mentionedUserIds.clear();
                        mentionedUserIds.addAll(newMentionedUserIds);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> extractUserIdsFromModel(String text) {
    Set<int> uniqueIds = Set<int>();
    for (UserProfile userProfile in data) {
      if (text.contains('@${userProfile.fullName}')) {
        uniqueIds.add(userProfile.id);
      }
    }
    return List<int>.from(uniqueIds);
  }
}

class UserProfile {
  final int id;
  final String fullName;
  final String sgid;
  final String content;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.sgid,
    required this.content,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      sgid: json['sgid'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'display': fullName,
      'photo': content,
    };
  }
}


