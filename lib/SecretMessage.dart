import 'package:flutter/material.dart';
import 'package:registration_form/Login.dart';

class SecretMessage extends StatefulWidget {
  SecretMessage({Key key, this.msg}) : super(key: key);

  final String msg;

  @override
  _SecretMessageState createState() => _SecretMessageState();
}

class _SecretMessageState extends State<SecretMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.msg),
          RaisedButton(
            child: Text("Back"), onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
            },
          )
        ],
      ),
    );
  }
}
