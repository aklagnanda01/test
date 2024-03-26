import 'package:flutter/cupertino.dart';
import 'package:testprojet/database/sql.database.dart';
import 'package:testprojet/entites/comment.entity.dart';
import 'package:testprojet/entites/posts.entity.dart';

class ErrorService extends ChangeNotifier{
  bool _isError = false;

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
  }

  void errorDetected(){
     isError = true;
    notifyListeners();
  }
  void errorNoDetected(){
    isError = false;
    notifyListeners();
  }
}

class PostService extends ChangeNotifier {

  Future<int> addPost(Post post) async{
    notifyListeners();
    return await SQLDB.insertPost(post);
  }

  void deletePost(Post post) {
    notifyListeners();
    SQLDB.deletePost(post.getId);

  }

  Future<Post> getPost(int id) async {
    notifyListeners();
    return await SQLDB.getPost(id);
  }

  Future<List<Post>> getListPost() async {
    notifyListeners();
    return await SQLDB.getListPost();
  }
  Future<int> updatePost(Post post) async {
    notifyListeners();
    return await SQLDB.updatePost(post);
  }

}
  class CommentService extends ChangeNotifier{

  Future<Comment> getComment(int id)async{
  return await SQLDB.getCommentaire(id);
  }

  Future<int> addComment(Comment cmt) async{
    notifyListeners();
    return await SQLDB.insertCommentaire(cmt);

  }
  Future<List<Comment>> getListComment() async {
  return await SQLDB.getListCommentaire();

  }}
