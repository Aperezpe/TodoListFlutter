import 'package:flutter/material.dart';
import 'Registration.dart';
import 'MyLists.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  Future<String> login(String username, String password) async {
    var url =
        'https://sleepy-hamlet-97922.herokuapp.com/api/login?username=$username&password=$password';
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
    print(responseJson.runtimeType);

    if (response.statusCode == 401) {
      //var msg = responseJson["message"];
      return (response.statusCode).toString();
    }

    var token = responseJson["token"];

    return token;
  }

  // Future<String> getSecretMessage(String token) async {
  //   //try to retrieve secret
  //   //set HttpHeaders.authorizationHeader to Bearer token
  //   var msg;
  //   String url = 'https://sleepy-hamlet-97922.herokuapp.com/secret';
  //   final response = await http.get(
  //     url,
  //     headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
  //   );
  //   final responseJson = json.decode(response.body);
  //   msg = responseJson["message"];

  //   return msg;

  //   //if successful, that is, status is 200
  //   //parse the response
  //   //return the secret message
  //   //if not successful, return null
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Login"),
            TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            TextField(
              controller: passwordCtrl,
              decoration: InputDecoration(hintText: 'Password'),
            ), 
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                String t = await login(usernameCtrl.text, passwordCtrl.text);

                if (t != "401") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLists(token: t)),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("Register now!"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()),
                    );
                  },
                ),
                FlatButton(
                  child: Text("Forgot password?"),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   // MaterialPageRoute(builder: (context) => LoginScreen()),
                    // );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
