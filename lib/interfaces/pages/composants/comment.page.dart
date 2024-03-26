import 'package:flutter/material.dart';
import 'package:testprojet/entites/comment.entity.dart';
import 'package:testprojet/entites/posts.entity.dart';

class CommentPage extends StatefulWidget {
  final Post post;
  final List<Comment> comment;
  const CommentPage({required this.post, required this.comment, Key? key})
      : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaires"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.comment.length,
          itemBuilder: (context, index) => commentWidget(widget.comment[index]),
        ),
      ),
    );
  }
}

Widget commentWidget(Comment cmt) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cmt.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          cmt.email,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 16),
        Text(
          cmt.body,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
