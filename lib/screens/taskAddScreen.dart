import 'package:createTask/provider/taskprovider.dart';
import 'package:createTask/widget/imageinput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class TaskAdd extends StatelessWidget {
  static const routeName = '/addItem';
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final commentController = TextEditingController();
    final item = ModalRoute.of(context).settings.arguments;
    File _pickedImage;
    void _selectImage(File pickedImage) {
      _pickedImage = pickedImage;
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(120, 20, 200, 6),
      appBar: AppBar(
        title: Text('Add The Task'),
        backgroundColor: Color.fromRGBO(20, 20, 2, 0.6),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            color: Colors.greenAccent,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Title",
                    contentPadding: EdgeInsets.all(12),
                  ),
                  controller: titleController,
                ),
                TextField(
                  decoration: InputDecoration(
                      focusColor: Colors.white,
                      labelText: "Comment",
                      contentPadding: EdgeInsets.all(12)),
                  controller: commentController,
                ),
                ImageInput(_selectImage)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.plus_one,
          color: Colors.black,
        ),
        onPressed: () {
          Provider.of<TaskProvider>(context, listen: false).addtasktoList(
              titleController.text, commentController.text, item, _pickedImage);
          Navigator.pop(context);
        },
      ),
    );
  }
}
