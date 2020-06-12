import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/dialogboxWidget.dart';
import '../screens/homepageScreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> register(String username, String password) async {
    
    final url = 'http://192.168.0.111:5000/register';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': "application/json"},
      );

      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      print(jsonResponse['status']);
      if (jsonResponse['status'] == 'NotOk') {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              DialogueBoxWidget('User already exist'),
        );
      }
      if (jsonResponse['status'] == 'OK') {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString('username', jsonResponse['username']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage('You Post')),
              (route) => false);
        });
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginUser(String username, String password) async {
    final url = 'http://192.168.0.111:5000/login/$username';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'username': username, 'password': password},
        ),
        headers: {'Content-Type': "application/json"},
      );

      final jsonresponse = json.decode(response.body);
      print(jsonresponse['status']);
      if (jsonresponse['status'] == "NotOk") {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                DialogueBoxWidget("Passsword does not match"));
      }
      if (jsonresponse['status'] == "match") {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              DialogueBoxWidget('User does not match'),
        );
      }
      if (jsonresponse['status'] == "OK") {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          _isLoading = false;
          prefs.setString('username', jsonresponse['username']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage('Your Post')),
              (route) => false);
        });
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 300,
                      ),
                      Container(
                        color: Colors.grey,
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: usernameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              hintText: "Enter username"),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        child: TextField(
                          cursorColor: Colors.white,
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              hintText: "Enter password"),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          loginUser(
                              usernameController.text, passwordController.text);
                        },
                        child: Text('Login'),
                        color: Colors.yellowAccent,
                      ),
                      RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          register(
                              usernameController.text, passwordController.text);
                        },
                        child: Text('Sign Up Instead'),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
