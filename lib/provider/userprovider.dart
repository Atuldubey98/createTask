import 'package:createTask/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  List<Users> _listusers = [];
  List<Users> get listusers {
    return [..._listusers];
  }

  Future<void> fetchandSetUsers() async {
    final url = "http://192.168.0.100:5000/listusers";
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final extractedUsers = json.decode(response.body) as Map<String, dynamic>;
    List<Users> loadedItem = [];
    for (int i = 0; i < extractedUsers['data'].length; i++) {
      loadedItem.add(Users(username: extractedUsers['data'][i]['username']));
    }
    _listusers = loadedItem;
    notifyListeners();
  }
}
