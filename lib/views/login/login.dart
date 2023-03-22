import 'package:flutter/material.dart';
import 'package:redditech/controlers/auth.dart';
import 'package:redditech/widget/button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RedditAuth authService = RedditAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              text: "LOGIN WITH REDDIT",
              iconSrc: "assets/icons/reddit.png",
              onPressed: login,
            )
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    var message = await authService.fetchAutorization();

    if (message == "Success") {
      Navigator.pushNamed(context, 'home');
    }
  }
}
