import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';


class TodoItem {
  int id;
  String text;
  bool completed;
  int userId;

  //TodoItem(this.id, this.text, this.completed, this.userId);
  //Also can use it with curlys but I have to specify in the object like this: id: 1, text: "bla bla"...
  TodoItem({this.id, this.text, this.completed, this.userId});

  void toggle() async {
    completed = !completed;
    //do iternet code that updates the server
    //submit a patch request to server/todo_items?completed=
    //if(completed == true)
    var response = http.patch(
        "https://sleepy-hamlet-97922.herokuapp.com/todo_items/$id?completed=${!completed}");
    // headers: {HttpHeaders.authorizationHeader: "Bearer $token";});
    // if(response.statusCode !=200){
    //   completed = !completed;
    // }
  }


  //Mejor hacemos un factory para crear un objeto y transferir todo el JSON en dart objects
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
        id: json["id"],
        text: json["text"],
        completed: json["completed"],
        userId: json["user_id"]);
  }
}

//Asi se crea un objeto, pero no haremos esto (;)
// TodoItem item = TodoItem(1, "TAKE OUT TRASH", false, 2);
