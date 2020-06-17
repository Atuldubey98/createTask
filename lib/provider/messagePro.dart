import 'package:createTask/models/mess.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessagePro with ChangeNotifier {
  List<MessagesProvider> _list = [];
  List<MessagesProvider> get list {
    return [..._list];
  }

  Future<void> fetchPost(String receiver, String sender) async {
    final url = 'http://192.168.0.100:5000/allchat/$sender/$receiver';
    final response = await http.get(url);
    List<MessagesProvider> loadedItem = [];
    if (response.statusCode == 200) {
      final extractedChat = json.decode(response.body) as Map<String, dynamic>;
      for (int i = 0; i < extractedChat['data'].length; i++) {
        loadedItem.add(
          MessagesProvider(
            message: extractedChat['data'][i]['message'],
          ),
        );
      }
      print(extractedChat['data']);
    }
    print(response.statusCode);
    _list = loadedItem;
    notifyListeners();
  }
  Future<void> sendMessage(String receiver,String mess, String sender)async{
    final newObject = MessagesProvider(message: mess);
    _list.add(newObject);
    final url = 'http://192.168.0.100:5000/sendmessage';
    final response = await http.post(url, body:json.encode({
      '_id' : DateTime.now().toString(),
      'message' : mess,
      'from_user' : sender,
      'to_user' : receiver
    }),headers: {"Content-Type" : "application/json"});
    print(response.body);
    notifyListeners();
  }
}
