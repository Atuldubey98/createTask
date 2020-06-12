import 'package:createTask/provider/taskprovider.dart';
import 'package:createTask/widget/listitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPost extends StatefulWidget {
  static const routeName = '/allpost';

  @override
  _AllPostState createState() => _AllPostState();
}

class _AllPostState extends State<AllPost> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
    }
    Provider.of<TaskProvider>(context, listen: false)
        .fetchandsetALL()
        .then((_) {
      setState(() {
        _isLoading = false;
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
        title: Text('All Post'),
        backgroundColor: Color.fromRGBO(20, 20, 2, 0.6),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<TaskProvider>(
              child: Text('No Posts By other Users'),
              builder: (context, listitem, child) =>
                  Provider.of<TaskProvider>(context, listen: false)
                              .list
                              .length <=
                          0
                      ? child
                      : ListView.builder(
                          itemCount: listitem.list.length,
                          itemBuilder: (context, index) => ListItem(
                              listitem.list[index].id,
                              listitem.list[index].title,
                              listitem.list[index].comments,
                              listitem.list[index].userID,
                              listitem.list[index].image))),
    );
  }
}
