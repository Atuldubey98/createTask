import 'package:createTask/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  List<Users> _listUser = [];
  String username;
  List<Users> get listUsers {
    return [..._listUser];
    
   
  }
   Future<void> getuser() async {
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username');

    }
  Future<void> fetchAndSetusers(String user) async {
    final url = 'http://192.168.0.100:5000/listusers/$user';
    final response = await http.get(url);
    final extracteduser = json.decode(response.body) as Map<String, dynamic>;
    List<Users> loadedItem = [];
    for (int i = 0; i < extracteduser['data'].length; i++) {
      loadedItem.add(Users(username: extracteduser['data'][i]['username']));
    }
    _listUser = loadedItem;
    getuser();
    notifyListeners();
  }
}
