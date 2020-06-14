import 'package:createTask/widget/singleItem.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ListAllItem extends StatelessWidget {
  final String id;
  final String title;
  final String comment;
  final String username;
  final File image;
  ListAllItem(this.id, this.title, this.comment, this.username, this.image);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.green,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ItemWidget(id, title, image, comment, username),
                ),
              );
            },
            trailing: Text(
              username,
              style: TextStyle(color: Colors.white),
            ),
            leading: CircleAvatar(
              foregroundColor: Colors.blueAccent,
              child: image == null
                  ? Text('No Image')
                  : Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
            ),
            contentPadding: EdgeInsets.all(10),
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              comment,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
