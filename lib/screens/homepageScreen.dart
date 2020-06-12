import 'package:createTask/provider/taskprovider.dart';
import 'package:createTask/screens/allpost.dart';
import 'package:createTask/screens/taskAddScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/listitem.dart';
import 'auth.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage(this.title);

  static const routeName = '/list';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isInit = true;
  var _isloading = false;
  var username;
  
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false);
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username');
      Provider.of<TaskProvider>(context, listen: false)
          .fetchAndSetPlaces(prefs.getString('username'))
          .then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(120, 20, 200, 6),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20, 20, 2, 0.6),
        title: Text(widget.title),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pushNamed(AllPost.routeName);
              });
           
            },
            elevation: 10,
            child: Text(
              'All Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              Navigator.of(context).pushNamed(TaskAdd.routeName,
                  arguments: prefs.getString('username'));
            },
            elevation: 10,
            child: Text(
              "Add Item",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                logout();
              })
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator(backgroundColor: Colors.green,semanticsLabel: "Loading Posts",))
          : Consumer<TaskProvider>(
              child: Center(
                child: Text("Add Item",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    )),
              ),
              builder: (context, taskobject, ch) =>
                  Provider.of<TaskProvider>(context, listen: false)
                              .list
                              .length <=
                          0
                      ? ch
                      : ListView.builder(
                          itemBuilder: (context, index) => ListItem(
                              taskobject.list[index].id,
                              taskobject.list[index].title,
                              taskobject.list[index].comments,
                              username,
                              taskobject.list[index].image
                              ),
                          itemCount: taskobject.list.length),
            ),
    );
  }
}
