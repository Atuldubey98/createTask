import 'package:createTask/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'allpost.dart';
import '../screens/homepageScreen.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
    }
    Provider.of<UserProvider>(context,listen: false).fetchandSetUsers().then((_) {
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
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
              builder: (context, item, child) => item.listusers.length <= 0
                  ? child
                  : ListView.builder(
                      itemCount: item.listusers.length,
                      itemBuilder: (_, index) => ListTile(
                          leading: Text(item.listusers[index].username))),
            ),
    );
  }
}
