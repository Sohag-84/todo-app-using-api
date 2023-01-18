// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_using_api/Screens/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTodoScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: getApi,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final id = items[index]['_id'] as String;

              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(
                  "${items[index]['title']}",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text("${items[index]['description']}"),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "edit") {
                    } else if (value == 'delete') {
                      //delete todo
                      deleteById(id: id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> getApi() async {
    String uri = "https://api.nstack.in/v1/todos?page=1&limit=10";
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
    log(response.body);
    print(response.statusCode);
  }

  //delete todo
  Future<void> deleteById({required id}) async {
    //delete the item
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    //remove from the list
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      Fluttertoast.showToast(msg: "Something is wrong!");
    }
  }
}
