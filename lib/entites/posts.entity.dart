import 'dart:convert';

import 'package:testprojet/entites/comment.entity.dart';

class Post {
  int? id;
  String title;
  String body;
  List<Comment>? comentaires = [];
  Post({
    this.id,
    required this.title,
    required this.body,
     comentaires
  });

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  String get getBody => body;

  set setBody(String body) => this.body = body;

  int get getId => id!;

   set setCommentaire(List<Comment> cmt) => comentaires = cmt;

  List<Comment>? get getCommentaire => comentaires;


  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

 

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'title': title});
    result.addAll({'body': body});
    //result.addAll({'comentaires': comentaires.map((x) => x.toMap()).toList()});
  
    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      body: map['body'] ?? '',
     // comentaires: List<Comment>.from(map['comentaires']?.map((x) => Comment.fromMap(x))),
    );
  }

  factory Post.fromMapEntyty(Map<String, dynamic> map, List<Comment> cmt) {
    return Post(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      comentaires: cmt,
    );
  }
}
