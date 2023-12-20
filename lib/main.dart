import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

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

  List<Map<String,dynamic>> data=[         
                      {
                        'id': '61ass61fsa',
                        'display': 'Shubham',
                        'photo':
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                      },
                      {
                        'id': '61asasssgasgsag6a',
                        'display': 'diwakr',
                        'style': const TextStyle(color: Colors.purple),
                        'photo':
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                      },
                      {
                        'id': 'asfgascga41',
                        'display': 'Aman',
                        'photo':
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                      },
                      {
                        'id': 'asfsaf45ww1a',
                        'display': 'chiku',
                        'photo':
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                      },
     ];


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
                          data: data,
                        matchAll: false,
                          suggestionBuilder: (data) {
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      data['photo'],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      // Text(data['full_name']),
                                        CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      data['photo'],
                                    ),
                                    radius: 5,
                                  ),
                                      Text('${data['display']}'),
                                    ],
                                  )
                                ],
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
       