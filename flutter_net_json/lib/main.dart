import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1',
      headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"}
  );

  final responseJson = json.decode(response.body);

  return Post.fromJson(responseJson);

  /*if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }*/
}

class Post{
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    this.id,
    this.userId,
    this.title,
    this.body
  });

  factory Post.fromJson(Map<String ,dynamic> json){
    return Post(
        userId:json['userId'],
        id:json['id'],
        title: json['title'],
        body: json['body']
    );
  }
}

void main() => runApp(MyApp(post:fetchPost()));

class MyApp extends StatelessWidget{
  final Future<Post> post;

  MyApp({Key key,this.post}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
              future: post,
              builder:(context,snapshot){
                if(snapshot.hasData){
                  return Text(snapshot.data.title);
                }else{
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
          ),
        ),
      ),
    );
    
  }
}