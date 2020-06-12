import 'package:flutter/cupertino.dart';
import 'dart:io';
class Task with ChangeNotifier {
  final String title;
  final String comments;
  final String id;
  final String userID;
  final File image;
  Task({ this.id, this.title,  this.comments, this.userID, this.image});
}
