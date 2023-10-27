import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _apiText = '';
  final apiKEY = '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';
  String searchText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: const Text(
                'You have pushed the button this many times:',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  final text = _apiText;
                  if (text == null) {
                    return Center (child: const CircularProgressIndicator());
                  }
                  return Text(
                    text,
                    style: TextStyle(
                        fontSize: 16
                    ),
                  );
                }
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '検索したいテキスト',
              ),
              onChanged: (text) {
                searchText = text;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  callAPI();
                },
                child: const Text('検索'),
            )
          ],
        ),
      ),
    );
  }

  void callAPI() async {
    final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKEY',
        },
        body: jsonEncode(<String, dynamic>{
        "model": "gpt-3.5-turbo",
        "messages": [
          { "role": "user", "content": searchText }
        ]
    }),
    );
    final body = response.bodyBytes;
    final jsonString = utf8.decode(body);
    final json = jsonDecode(jsonString);
    final choices = json['choices'];
    final content = choices[0]['message']['content'];
    setState(() {
      _apiText = content;
    });
  }
}
