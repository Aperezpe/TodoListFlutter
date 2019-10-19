import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/todoitem.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_slidable/flutter_slidable.dart';

class MyLists extends StatefulWidget {
  MyLists({Key key, this.token}) : super(key: key);

  final String token;

  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  TextEditingController _textFieldController = TextEditingController();
  
  //List<TodoItem> todoItems = new List<TodoItem>();

  Future<List<TodoItem>> _getLists() async {
    var response = await http.get(
      'https://sleepy-hamlet-97922.herokuapp.com/todo_items',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
    );

    var jsonData = json.decode(response.body);

    List<TodoItem> items = [];

    if(widget.token=="401"){
      print(widget.token);
      return [];
    }

    for (var i in jsonData) {
      if (i["text"] == null || i["text"] == " ") {
        continue;
      }
      TodoItem item =
          TodoItem(id:i["id"], text:i["text"],completed:i["completed"],userId:i["user_id"]);
          
     items.add(item);
    }

    print (items.length);

    return items;
  }

  Future<void> _toggle(bool value, int id) async {
    value = !value;

    //mark as completed
    var response = await http.patch(
      'https://sleepy-hamlet-97922.herokuapp.com/todo_items/$id?completed=${!value}',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      //setState(() {});
    } else {
      print("There was an error toggling");
    }

    setState(() {});
  }

  Future<void> _addItem(String input) async {
    final response = await http.post(
      'https://sleepy-hamlet-97922.herokuapp.com/todo_items?text=$input',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
    );

    if (response.statusCode == 201) {
      setState(() {});
    } else {
      print("There was an error adding the item");
    }
  }

  Future<void> _editItem(String input, dynamic data) async {
    final response = await http.patch(
      'https://sleepy-hamlet-97922.herokuapp.com/todo_items/${data.id}?text=$input',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
    );

    if (response.statusCode == 200) {
      setState(() {});
    } else {
      print("There was an error adding the item");
    }
  }

  Future<void> _removeItem(int id) async {
    //mark as completed
    var response = await http.delete(
      'https://sleepy-hamlet-97922.herokuapp.com/todo_items/$id',
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"},
    );

    if (response.statusCode == 200) {
      print("Item has been deleted");
      setState(() {});
      //setState(() {});
    } else {
      print("There was an error deleting the item");
    }

    //setState(() {});
  
  }

  _displayDialog(BuildContext context, dynamic data) async {
    print(context.runtimeType);

    if (context.runtimeType == SliverMultiBoxAdaptorElement) {
      _textFieldController.text = data.text;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit Item'),
              content: TextField(
                controller: _textFieldController,
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        _editItem(_textFieldController.text, data);
                        _textFieldController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            );
          });
    } else {
      _textFieldController.clear();
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Item'),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "New item..."),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        _addItem(_textFieldController.text);
                        
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Lists"),
        backgroundColor: const Color(0xFFF75C4F),
      ),
      body: Container(
          child: FutureBuilder(
        future: _getLists(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(child: Text("Loading...")),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  actionPane: new SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: CheckboxListTile(
                    title: Text(snapshot.data[index].text),
                    value: snapshot.data[index].completed,
                    onChanged: (bool value) {
                      _toggle(value, snapshot.data[index].id);
                    },
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => {_displayDialog(context, snapshot.data[index])},
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => {
                        _removeItem(snapshot.data[index].id),
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 10),
        child: FloatingActionButton(
          onPressed: () => _displayDialog(context, null), //The zero does not matter
          child: Icon(Icons.add),
          backgroundColor: const Color(0xFFF75C4F),
          elevation: 5.25,
        ),
      ),
    );
  }
}
