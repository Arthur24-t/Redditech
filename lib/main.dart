import 'package:flutter/material.dart';
import 'package:redditech/views/home.dart';
import 'package:redditech/views/login/login.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReddiTech',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        'login': (context) => const Login(),
        'home': (context) => const MyHomePage(
              subreddit: "best",
              after: "",
              before: "",
            ),
      },
      initialRoute: 'login',
    );
  }
}
