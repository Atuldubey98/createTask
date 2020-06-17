import 'package:createTask/provider/messagePro.dart';
import 'package:createTask/screens/allpost.dart';

import 'package:createTask/screens/homepageScreen.dart';

import 'package:createTask/screens/taskAddScreen.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './provider/taskprovider.dart';
import './provider/alluserprovider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TaskProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MessagePro(),
        )
      ],
      child: MaterialApp(
        title: 'TODO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage('You Post'),
        routes: {
          TaskAdd.routeName: (context) => TaskAdd(),
          AllPost.routeName: (context) => AllPost(),
        },
      ),
    );
  }
}
