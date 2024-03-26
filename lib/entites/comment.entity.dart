import 'dart:convert';

class Comment {
  int _postId;
  int? _id;
  String _name;
  String _email;
  String _body;
  Comment({
    required postId,
     int? id,
    required name,
    required email,
    required body,
  }):
   _postId = postId,
   _id = id,
   _name = name,
   _email = email,
   _body = body;
  
int get postId => _postId;

  set postId(int value) => _postId = value;

  get id => _id;

  set id(value) => _id = value;

  get name => _name;

  set name(value) => _name = value;

  get email => _email;

  set email(value) => _email = value;

  get body => _body;

  set body(value) => _body = value;


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'postId': _postId});
    if(_id != null){
      result.addAll({'id': _id});
    }
    result.addAll({'name': _name});
    result.addAll({'email': _email});
    result.addAll({'body': _body});
  
    return result;
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      postId: map['postId']?.toInt() ?? 0,
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      body: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));
}
