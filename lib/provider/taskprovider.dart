import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
class TaskProvider with ChangeNotifier {
  List<Task> _list = [];
  List<Task> get list {
    return [..._list];
  }

  Future<void> addtasktoList(String titleofTask, String commentofTask,
      String item, File imageFile) async {
    final newObject = Task(
        id: DateTime.now().toString(),
        title: titleofTask,
        comments: commentofTask,
        image: imageFile);
    _list.add(newObject);
    notifyListeners();
    final url = 'http://192.168.0.100:5000/addItem/$item';
    final String name = p.basename(imageFile.path);
    final urlImage =
        'http://192.168.0.100:5000/upload/${p.basename(imageFile.path)}/${newObject.id}';
    try {
      final response = await http.post(url,
          body: json.encode({
            '_id': newObject.id,
            'title': newObject.title,
            'comment': newObject.comments,
            'imageName': name
          }),
          headers: {"Content-Type": "application/json"});
      final response1 =
          await http.put(urlImage, body: await imageFile.readAsBytes());
      print(response1.body);
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      throw e;
    }
  }

  Future<File> fetchImage(String user, String filename, String itemId) async {
    final url = 'http://192.168.0.100:5000/download/$user/$filename/$itemId';
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> fetchAndSetPlaces(String username) async {
    final url = 'http://192.168.0.100:5000/$username';
    final extractedItem =
        await http.get(url, headers: {"Accept": "application/json"});
    final response = json.decode(extractedItem.body) as Map<String, dynamic>;
    print(response['data'].runtimeType);
    print(response);
    final prefs = await SharedPreferences.getInstance();
    List<Task> loadedItem = [];
    if(response['data'].length <= 0){
      _list = loadedItem;
      notifyListeners();
    }
    for (int i = 0; i < response['data'].length; i++) {
      loadedItem.add(Task(
          id: response['data'][i]['_id'],
          title: response['data'][i]['title'],
          comments: response['data'][i]['comment'],
          image: await fetchImage(prefs.getString('username'), response['data'][i]['imageName'],
              response['data'][i]['_id'])));
    }
    _list = loadedItem;

    notifyListeners();
  }

  Future<void> fetchandsetALL() async {
    final url = 'http://192.168.0.100:5000/allpost';
    final extractedItem =
        await http.get(url, headers: {"Accept": "application/json"});
    final response = json.decode(extractedItem.body) as Map<String, dynamic>;
    print(response['data']);
    List<Task> loadedItem = [];
    for (int i = 0; i < response['data'].length; i++) {
      loadedItem.add(Task(
        id: response['data'][i]['_id'],
        title: response['data'][i]['title'],
        comments: response['data'][i]['comment'],
        userID: response['data'][i]['username'],
        image: await fetchImage(response['data'][i]['username'], response['data'][i]['imageName'],
              response['data'][i]['_id'])
      ));
    }
    _list = loadedItem;
    notifyListeners();
  }

  Future<void> deleteItem(String idItem, String username, String filename) async {
    final existingItemindex =
        _list.indexWhere((element) => element.id == idItem);
    var existingItem = _list[existingItemindex];
    _list.remove(existingItem);
    notifyListeners();
    final url = 'http://192.168.0.100:5000/deleteItem/$username/$idItem/$filename';
    final response =
        await http.delete(url, headers: {"Accept": "application/json"});
    print(response.statusCode);
    if (response.statusCode > 400) {
      _list.insert(existingItemindex, existingItem);
      notifyListeners();
    }
    existingItem = null;
  }
}
