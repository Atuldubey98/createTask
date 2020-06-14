import 'package:createTask/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/allpost.dart';
import '../screens/homepageScreen.dart';

class AllUsers extends StatefulWidget {
  static const routeName = '/allusers';
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  var _isInit = true;
  var _isloading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
    }
    Provider.of<UserProvider>(context, listen: false)
        .fetchandSetUsers()
        .then((_) {
      setState(() {
        _isloading = false;
      });
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(120, 20, 200, 6),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20, 20, 2, 0.6),
        title: Text('Your Friends'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pushReplacementNamed(AllPost.routeName);
              });
            },
            elevation: 10,
            child: Text(
              'All Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            onPressed: () {
              setState(
                () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage('Your Post'),
                      ),
                      (route) => false);
                },
              );
            },
            child: Text(
              'Your Post',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: _isloading
          ? CircularProgressIndicator()
          : Consumer<UserProvider>(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              builder: (context, user, ch) => ListView.builder(
                itemCount: user.listusers.length,
                itemBuilder: (context, index) => user.listusers.length < 0
                    ? ch
                    : Card(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.yellowAccent,
                                Colors.lightBlueAccent
                              ],
                            ),
                          ),
                          child: ListTile(
                            leading: Text(
                              user.listusers[index].username,
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: CircleAvatar(
                              child: Text('1'),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}
