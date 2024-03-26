import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testprojet/entites/posts.entity.dart';

void  postDialogue(BuildContext context, String text,List<Post> postList, {Post? post}) async{
  final formKey = GlobalKey<FormState>();
  String title = '';
  String body = '';
  showDialog(
    context: context,
    builder: (context) => Center(
      child: SimpleDialog(
        contentPadding: const EdgeInsets.all(25),
        title: Text('Ajout d\'un Post'),
        children: [
          Form(
            key: formKey,
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
                  decoration: const InputDecoration(
                      labelText: 'Saisir une description'),
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
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Post post0 = Post(title: title, body: body);
                    postList.add(post0); // Ajout du post à la liste principale
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
}
