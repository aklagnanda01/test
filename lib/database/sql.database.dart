import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:testprojet/entites/comment.entity.dart';
import 'package:testprojet/entites/posts.entity.dart';

class SQLDB {
  static Future<sql.Database> db() async {
    return sql.openDatabase('dbOvasion', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTablePost(database);
      await createTableCommentaire(database);
    });
  }

  //                        \\
  //                         \\
  //la table de commentaire  \\
  //                          \\
  //                           \\

  static String table2 = "commentaire";
  static String idCm = 'id';
  static String postId = 'postId';
  static String name2 = 'name';
  static String email2 = 'email';
  static String body = 'body';
  // Create Commentaire table in the database
  static Future<void> createTableCommentaire(sql.Database database) async {
    await database.execute("""CREATE TABLE $table2 (
        $idCm INTEGER PRIMARY KEY AUTOINCREMENT,
        $postId INTEGER NOT NULL,
        $name2 TEXT NOT NULL ,
        $email2 TEXT,
        $body TEXT 
      )
    """);
  }

  // Insert a Commentaire into the database
  static Future<int> insertCommentaire(Comment comment) async {
    Database db = await SQLDB.db();
    var result = await db.insert(table2, comment.toMap());
    return result;
  }

  // Retrieve the list of Commentaires from the database
  static Future<List<Map<String, dynamic>>> _getMapListCommentaire() async {
    final db = await SQLDB.db();
    var result = await db.query(table2, orderBy: "$name2 ASC");
    return result;
  }

  // Retrieve the list of Commentaires from the database
  static Future<List<Map<String, dynamic>>> _getMapListCommentaireId(int id) async {
    final db = await SQLDB.db();
    var result = await db.query(table2,
        where: "$postId = ?", whereArgs: [id], orderBy: "$name2 ASC");
    return result;
  }

  // Retrieve a specific Commentaire from the database
  static Future<List<Map<String, dynamic>>> _getCommentaire(int id) async {
    final db = await SQLDB.db();
    var result =
        await db.query(table2, where: "$idCm = ?", whereArgs: [id], limit: 1);
    return result;
  }

  // Update a Commentaire in the database
  static Future<int> updateCommentaire(Comment Commentaire) async {
    Database db = await SQLDB.db();
    var result = await db.update(table2, Commentaire.toMap(),
        where: "$idCm = ?", whereArgs: [Commentaire.id]);
    return result;
  }

  // Delete a Commentaire from the database
  static Future<int> deleteCommentaire(int id) async {
    final db = await SQLDB.db();
    var result = await db.delete(table2, where: "$idCm = ?", whereArgs: [id]);
    return result;
  }

  // Retrieve the count of Commentaires in the database
  static Future<int> getCommentaireCount() async {
    final db = await SQLDB.db();
    final x = await db.rawQuery("SELECT COUNT(*) FROM $table2");
    int? result = sql.Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  // Retrieve the list of Commentaires as a list of Commentaire objects
  static Future<List<Comment>> getListCommentaire() async {
    var result = await _getMapListCommentaire();
    return result.map((e) => Comment.fromMap(e)).toList();
  }

  static Future<List<Comment>> getListCommentaireId(int id) async {
    var result = await _getMapListCommentaireId(id);
    return result.map((e) => Comment.fromMap(e)).toList();
  }

  // Retrieve a specific Commentaire as a Commentaire object
  static Future<Comment> getCommentaire(int id) async {
    var result = await _getCommentaire(id);
    var x = result.map((e) => Comment.fromMap(e)).toList();
    return x.first;
  }

  //                        \\
  //                         \\
  //la table de Post  \\
  //                          \\
  //                           \\

  static String table3 = "post";
  static String idPost = 'id';
  static String title = 'title';
  static String bodyPost = 'body';
  // Create post table in the database
  static Future<void> createTablePost(sql.Database database) async {
    await database.execute("""CREATE TABLE $table3 (
        $idPost INTEGER PRIMARY KEY AUTOINCREMENT,
        $title TEXT NOT NULL ,
        $body TEXT 
      )
    """);
  }

  // Insert a post into the database
  static Future<int> insertPost(Post post) async {
    Database db = await SQLDB.db();
    var result = await db.insert(table3, post.toMap());
    // for (Comment cmt in post.comentaires) {
    //   await insertCommentaire(cmt);
    // }
    return result;
  }

  // Retrieve the list of post from the database

  static Future<List<Map<String, dynamic>>> _getMapListPost() async {
    final db = await SQLDB.db();
    var result = await db.query(table3, orderBy: "$title ASC");
    return result;
  }

  // Retrieve a specific post from the database
  static Future<List<Map<String, dynamic>>> _getPost(int id) async {
    final db = await SQLDB.db();
    var result =
        await db.query(table3, where: "$idPost = ?", whereArgs: [id], limit: 1);
    return result;
  }

  // Update a post in the database
  static Future<int> updatePost(Post post) async {
    Database db = await SQLDB.db();
    var result = await db.update(table3, post.toMap(),
        where: "$idPost = ?", whereArgs: [post.id]);
    return result;
  }

  // Delete a post from the database
  static Future<int> deletePost(int id) async {
    final db = await SQLDB.db();
    var result = await db.delete(table3, where: "$idPost = ?", whereArgs: [id]);
    return result;
  }

  // Retrieve the count of post in the database
  static Future<int> getPostCount() async {
    final db = await SQLDB.db();
    final x = await db.rawQuery("SELECT COUNT(*) FROM $table3");
    int? result = sql.Sqflite.firstIntValue(x);
    return result ?? 0;
  }

  // Retrieve the list of post as a list of Commentaire objects
  static Future<List<Post>> getListPost() async {
    var result = await _getMapListPost();
    List<Post> _posListe = [];
    for (Map<String, dynamic> e in result) {
      List<Comment> cmt = await getListCommentaireId(e[idPost]);
      _posListe.add(Post.fromMapEntyty(e, cmt));
    }
    return _posListe;
  }

  // Retrieve a specific post as a Post object
  static Future<Post> getPost(int id) async {
    var result = await _getPost(id);
    final res = result.first;
    List<Comment> cmt = await getListCommentaireId(res["$idPost"]);
    var x = Post.fromMapEntyty(res, cmt);
    return x;
  }
}
