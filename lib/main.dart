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
      builder: (_, child) => 
      Portal(child: child!),
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

    @override
  void initState() {
    super.initState();
    fetchData();
  }

 Future<void> fetchData() async {
    const String token =
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoyLCJ0aW1lIjoxNzAxOTQ0NjE1fQ.ZCl1pDug6j90L4HqVcCjNMSYF3wRuRac1gy9XPUyXZY';
      final response = await http.get(Uri.parse('https://staging.simmpli.com/api/v1/profiles/mentions.json?q='),headers: {'Authorization': token});


   
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        data = responseData.map((json) => UserProfile.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }





  // List<Map<String,dynamic>> data=[         
  //                     {
  //                       'id': '61ass61fsa',
  //                       'display': 'Shubham',
  //                       'photo':
  //                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //                     },
  //                     {
  //                       'id': '61asasssgasgsag6a',
  //                       'display': 'diwakr',
  //                       'style': const TextStyle(color: Colors.purple),
  //                       'photo':
  //                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //                     },
  //                     {
  //                       'id': 'asfgascga41',
  //                       'display': 'Aman',
  //                       'photo':
  //                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //                     },
  //                     {
  //                       'id': 'asfsaf45ww1a',
  //                       'display': 'chiku',
  //                       'photo':
  //                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
  //                     },
  //    ];


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
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                 height: 50,
                  decoration:  BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius:
                        BorderRadius.all(Radius.circular(9)),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FlutterMentions(
                    key: key,
                    suggestionPosition: SuggestionPosition.Top,
                    maxLines: 5,
                    minLines: 1,
                    decoration:InputDecoration
                          (
                            border: InputBorder.none,
                            hintText: 'Write your comment',
                            suffixIcon: IconButton(
                              onPressed: () 
                              {                        
                              
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
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data['photo'],
                                      ),
                                      radius: 10,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        // Text(data['full_name']),
                                    //       CircleAvatar(
                                    //   backgroundImage: NetworkImage(
                                    //     data['photo'],
                                    //   ),
                                    //   radius: 5,
                                    // ),
                                        Text('${data['display']}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      'display': fullName, // Adjust accordingly based on your data structure
      'photo': content, // Adjust accordingly based on your data structure
    };
  }
}