import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/taskprovider.dart';
import 'dart:io';

class ListItem extends StatelessWidget {
  final String id;
  final String titleoftask;
  final String commentoftask;
  final String username;
  final File image;
  ListItem(
      this.id, this.titleoftask, this.commentoftask, this.username, this.image);
  @override
  Widget build(BuildContext context) {
    void deleteItem(String itemId) {
      Provider.of<TaskProvider>(context, listen: false)
          .deleteItem(itemId, username);
    }

    return Column(
      children: <Widget>[
        Card(
          color: Colors.green,
          child: ListTile(
              trailing: Text(
                username,
                style: TextStyle(color: Colors.white),
              ),
              leading: CircleAvatar(
                foregroundColor: Colors.blueAccent,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              contentPadding: EdgeInsets.all(10),
              title: Text(
                titleoftask,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                commentoftask,
                style: TextStyle(color: Colors.white),
              ),
              onLongPress: () => deleteItem(id)),
        ),
        Divider()
      ],
    );
  }
}
