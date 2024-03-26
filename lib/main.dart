import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojet/interfaces/pages/pages/acceuil.page.dart';
import 'package:testprojet/services/fonctions/services.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ErrorService()),
    ChangeNotifierProvider(create: (context) => PostService()),
    ChangeNotifierProvider(create: (context) => CommentService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PUB APP ',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 2, 15, 80)),
        useMaterial3: true,
      ),
      home: const PageAceeuil(title: 'P U B   A P P'),
    );
  }
}
