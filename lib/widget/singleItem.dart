import 'package:flutter/material.dart';
import 'dart:io';

class ItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String comment;
  final String username;
  final File image;
  ItemWidget(this.id, this.title, this.image, this.comment, this.username);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
              child: Container(
                  
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green, Colors.orangeAccent],
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Image.file(image),
              ),
              Container(
                decoration: BoxDecoration(),
                child: ListTile(
                    leading: Text(
                      username,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(comment),
                    trailing: Icon(Icons.favorite_border)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
