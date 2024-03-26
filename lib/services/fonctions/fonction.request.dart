import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:testprojet/entites/comment.entity.dart';
import 'package:testprojet/entites/posts.entity.dart';
import 'package:testprojet/services/fonctions/services.dart';

class Request {
  static Future<List<Post>> request(BuildContext context,
      {int debut = 1, int fin = 10}) async {
    List<Post> _posts = [];
    bool error = false;
    try {
      for (int i = debut; i < fin; i++) {
        final url = 'https://jsonplaceholder.typicode.com/posts/$i';
        final uri = Uri.parse(url);
        final response = await http.get(uri);
        final url2 = 'https://jsonplaceholder.typicode.com/posts/$i/comments';
        final uri2 = Uri.parse(url2);
        final response2 = await http.get(uri2);

        if (response.statusCode == 200 || response2.statusCode == 200) {
          Map<String, dynamic> valeurs =
              await jsonDecode(response.body) as Map<String, dynamic>;
          List<dynamic> valeurs2 = await jsonDecode(response2.body);
           List<Comment> comments = [];
          for (dynamic map in valeurs2) {
            Comment cmt = Comment.fromMap(map);
            comments.add(cmt);
            //await Provider.of<CommentService>(context, listen: false).addComment(cmt);
            print("Error status code1: ${map}");
            print("Error status code2: ${Comment.fromMap(map).email}");

          }
          Post _post = Post.fromMap(valeurs);
           //await Provider.of<PostService>(context, listen: false).addPost(_post);
          _post.setCommentaire = comments;
          print("akllesssoooe: ${comments[2].email}");
          _posts.add(_post);
          print(
              "la longeur est+${valeurs["body"]}+les donnees sont ${valeurs.length}");
        } else {
          print("Error status code: ${response.statusCode}");
          error = true;
        }
      }
      print(
          "Error status : ${_posts.length}et le titre est ${_posts[3].title}");
      Provider.of<ErrorService>(context, listen: false).errorNoDetected();
    } catch (e) {
      print("Error during HTTP request: $e");
      error = true;
      Provider.of<ErrorService>(context, listen: false).errorDetected();
    }
    if (error) {
      _posts =
      await Provider.of<PostService>(context, listen: false).getListPost();
      Provider.of<ErrorService>(context, listen: false).errorDetected();
    }
    return _posts;
  }
}
