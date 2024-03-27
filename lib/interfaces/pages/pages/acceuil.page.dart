import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojet/entites/posts.entity.dart';
import 'package:testprojet/interfaces/pages/composants/comment.page.dart';
import 'package:testprojet/services/fonctions/fonction.request.dart';
import 'package:testprojet/services/fonctions/services.dart';

class PageAceeuil extends StatefulWidget {
  final String title;
  const PageAceeuil({required this.title, super.key});

  @override
  State<PageAceeuil> createState() => _PageAceeuilState();
}

class _PageAceeuilState extends State<PageAceeuil> {
  List<Post> _postList = [];
  bool _recharge = false;
  final ScrollController _controller = ScrollController();
  int _index = 11;
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void ajoutPost(Post post) {
    _postList.isEmpty ? _postList.add(post) : _postList.insert(0, post);
      Provider.of<PostService>(context,listen: false).addPost(post);
  }

  void suppressionPost(int index) {
     Provider.of<PostService>(context,listen: false).deletePost(_postList[index]);
    _postList.removeAt(index);
  }

  void modifPost(int index, Post post) {
    Provider.of<PostService>(context,listen: false).updatePost(_postList[index]);
    _postList[index] = post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("Publication APP",textAlign: TextAlign.center,),
        actions: [
          IconButton(icon: const Icon(Icons.refresh),onPressed: (){
            _scrollListener();
            setState(() {});
          }),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Consumer<ErrorService>(
              builder: (context, value, child) => value.isError
                  ? const Center(
                      child: Text(
                      "Erreur détectée vérifier votre connexion internet ",
                      textAlign: TextAlign.justify,
                    ))
                  : const SizedBox()),
          Consumer<PostService>(
            builder: (context, value, child) => Expanded(
              child: Center(
                child: FutureBuilder(
                  future: ( _postList.isEmpty && !_recharge)
                      ? Request.request(context)
                      : _scrollListener(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_postList.isEmpty) {
                        _postList.addAll(snapshot.requireData);
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: _controller,
                        itemCount: _postList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CommentPage(
                                    post: _postList[index],
                                    comment: _postList[index].getCommentaire!),
                              ));
                            },
                            leading: CircleAvatar(
                                child: Center(
                              child: Text(_postList[index].id.toString()),
                            )),
                            title: Text(
                              _postList[index].title,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              _postList[index].body,
                              maxLines: 2,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    final formKey = GlobalKey<FormState>();
                                    String title = _postList[index].title;
                                    String body = _postList[index].body;
                                    showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: SimpleDialog(
                                          contentPadding:
                                              const EdgeInsets.all(25),
                                          title: const Text(
                                              'Modification de d\'un Post'),
                                          children: [
                                            Form(
                                              key: formKey,
                                              child: Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText: 'Titre'),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Veuillez entrer un titre valide';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      title = value!;
                                                    },
                                                    initialValue: title,
                                                  ),
                                                  TextFormField(
                                                    maxLines: null,
                                                    keyboardType: TextInputType.multiline,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'saisir une description'),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Veuillez saisir une description';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      body = value!;
                                                    },
                                                    initialValue: body,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Annuler'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      formKey.currentState!
                                                          .save();
                                                      modifPost(
                                                          index,
                                                          Post(id: _postList[index].id,
                                                              title: title,
                                                              body: body));
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('Modifier'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    suppressionPost(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Display error message
                      return Text(snapshot.error.toString());
                    }
                    // Display loading indicator while waiting for data
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.grey,
                        color: Colors.blue,
                        semanticsLabel: 'chargement en cours ... ',
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final formKey0 = GlobalKey<FormState>();
          String title = '';
          String body = '';
          showDialog(
            context: context,
            builder: (context) => Center(
              child: SimpleDialog(
                contentPadding: const EdgeInsets.all(25),
                title: const Text('Ajout d\'un Post'),
                children: [
                  Form(
                    key: formKey0,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Titre'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un titre valide';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            title = value!;
                          },
                        ),
                        TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              labelText: 'saisir une description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez saisir une description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            body = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey0.currentState!.validate()) {
                            formKey0.currentState!.save();
                            ajoutPost(Post(title: title, body: body));
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Ajouter'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Post>> _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _recharge = true;
      _index = _postList.length + 1;
      _postList = _postList +
          await Request.request(context, debut: _index, fin: _index + 5);
      setState(() {
        _index = _postList.length + 5;
      });
    } else {
      _recharge = false;
    }
    return _postList;
  }
}
