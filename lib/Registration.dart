//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController rePasswordCtrl = TextEditingController();

  Future<String> register(
      String username, String password, String rePassword) async {
    //try to login to https://sleepy-hamlet-97922.herokuapp.com/api/login

    //if successful, that is, status is 200
    //parse the response
    //return the token

    //if not successful return null
    var msg;

    if (password != rePassword) {
      msg = "Passwords don't match!";
      return msg;
    }

    String url =
        'https://sleepy-hamlet-97922.herokuapp.com/api/register?username=$username&password=$password';

    final response = await http.post(url);

    final responseJson = json.decode(response.body);

    msg = responseJson["message"];

    return msg;
  }

  //Future<String> getSecretMessage(String token) async {
    //try to retrieve secret
    //set HttpHeaders.authorizationHeader to Bearer token

    //if successful, that is, status is 200
    //parse the response
    //return the secret message
    //if not successful, return null
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 10),
            child: TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(
                hintText: 'Username',
                icon: Icon(
                  Icons.person_outline,
                  size: 35.0,
                ),
              ),
            ),
          ),
          // TextField(
          //   decoration: InputDecoration(hintText: 'Email'),
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 10),
            child: TextField(
              controller: passwordCtrl,
              decoration: InputDecoration(
                  hintText: 'Password',
                  icon: Icon(
                    Icons.lock_outline,
                    size: 30.0,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 10),
            child: TextField(
              controller: rePasswordCtrl,
              decoration: InputDecoration(
                  hintText: 'Retype password',
                  icon: Icon(
                    Icons.lock_outline,
                    size: 30.0,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: RaisedButton(
              child:
                  // width:double.infinity,
                  Text("REGISTER NOW"),
              onPressed: () async {
                String msg = await register(
                    usernameCtrl.text, passwordCtrl.text, rePasswordCtrl.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SuccesfulRegistration(msg: msg)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Aleady have an account? "),
                FlatButton(
                  child: Text("Login"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuccesfulRegistration extends StatefulWidget {
  SuccesfulRegistration({Key key, this.msg}) : super(key: key);

  final String msg;

  @override
  _SuccesfulRegistrationState createState() => _SuccesfulRegistrationState();
}

class _SuccesfulRegistrationState extends State<SuccesfulRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.msg),
          RaisedButton(
            child: Text("Back"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
