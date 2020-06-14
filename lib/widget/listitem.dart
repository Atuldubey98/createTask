import 'package:createTask/widget/singleItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/taskprovider.dart';
import 'dart:io';
import 'package:path/path.dart';

class ListItem extends StatefulWidget {
  final String id;
  final String titleoftask;
  final String commentoftask;
  final String username;
  final File image;
  ListItem(
      this.id, this.titleoftask, this.commentoftask, this.username, this.image);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    void deleteItem(String itemId) {
      Provider.of<TaskProvider>(context, listen: false)
          .deleteItem(itemId, widget.username, basename(widget.image.path));
    }

    return Column(
      children: <Widget>[
        Card(
          color: Colors.green,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.yellowAccent, Colors.lightBlueAccent],
              ),
            ),
            child: ListTile(
                trailing: widget.username == null
                    ? Text('username')
                    : Text(
                        widget.username,
                        style: TextStyle(color: Colors.black),
                      ),
                leading: CircleAvatar(
                  backgroundColor: Colors.yellowAccent,
                  child: widget.image == null
                      ? Text('No Image')
                      : Image.file(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                ),
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  widget.titleoftask,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  widget.commentoftask,
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ItemWidget(
                              widget.id,
                              widget.titleoftask,
                              widget.image,
                              widget.commentoftask,
                              widget.username)),
                    );
                  });
                },
                onLongPress: () => deleteItem(widget.id)),
          ),
        ),
        Divider()
      ],
    );
  }
}
