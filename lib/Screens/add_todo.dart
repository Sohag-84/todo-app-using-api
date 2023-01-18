// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddTodoScreen extends StatelessWidget {
  AddTodoScreen({Key? key}) : super(key: key);

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
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
                addTodo();
              },
              child: Text("Add Todo"),
            ),
          ],
        ),
      ),
    );
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
      Fluttertoast.showToast(msg: "Creation failde");
    }
  }
}
