// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddTodoScreen extends StatefulWidget {
  final Map? item;
  const AddTodoScreen({Key? key, this.item}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();

  final _descController = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.item;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      _titleController.text = title;
      _descController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit == false ? "Add Todo" : "Edit Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
              ),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: "Enter description",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isEdit ? updateTodo() : addTodo();
              },
              child: Text(isEdit == false ? "Add Todo" : "Update Todo"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTodo() async {
    final todo = widget.item;
    if (todo == null) {
      log("You can't updated without todo data");
      return;
    }
    final id = todo['_id'];

    final title = _titleController.text;
    final description = _descController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    String url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Updation success");
      log(response.body);
    } else {
      Fluttertoast.showToast(msg: "Updation failed");
    }
  }

  Future<void> addTodo() async {
    final title = _titleController.text;
    final description = _descController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    String url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Creation success");
      _titleController.text = "";
      _descController.text = "";
      log(response.body);
    } else {
      Fluttertoast.showToast(msg: "Creation failed");
    }
  }
}
