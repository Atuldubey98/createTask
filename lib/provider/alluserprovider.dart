import 'package:createTask/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier{
  List<Users> _listUser = [];
  List<Users> get listUsers {
    return [..._listUser];
  }

  Future<void> fetchAndSetusers() async {
    final url = 'http://192.168.0.107:5000/listusers';
    final response = await http.get(url);
    final extracteduser = json.decode(response.body) as Map<String, dynamic>;
    List<Users> loadedItem = [];
    for (int i = 0; i < extracteduser['data'].length; i++) {
      loadedItem.add(Users(username: extracteduser['data'][i]['username']));
    }
  _listUser =loadedItem;
  notifyListeners();
  }
}
