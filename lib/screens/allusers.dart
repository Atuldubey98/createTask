import 'package:createTask/provider/alluserprovider.dart';
import 'package:createTask/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'allpost.dart';
import '../screens/homepageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    Provider.of<UserProvider>(context, listen: false)
        .fetchAndSetusers(username)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Friends'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AllPost.routeName);
            },
            elevation: 10,
            child: Text(
              'All Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyHomePage('Your Post'),
              ));
            },
            child: Text(
              'Your Post',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : Consumer<UserProvider>(
              child: Center(child: Text('No Friends You are So Lonely')),
              builder: (context, item, child) => item.listUsers.length <= 0
                  ? child
                  : ListView.builder(
                      itemCount: item.listUsers.length,
                      itemBuilder: (_, index) => ListTile(
                          onTap: () {
                            Navigator.of(_).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(item.listUsers[index].username),
                              ),
                            );
                          },
                          leading: Text(item.listUsers[index].username))),
            ),
    );
  }
}
