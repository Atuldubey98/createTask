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
    if (usernameController.text == "" ||
        passwordController.text == "" ||
        usernameController.text.length < 3 ||
        passwordController.text.length < 4) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogueBoxWidget('Enter Valid Username and Password'),
      );
    } else {
      final url = 'http://192.168.0.100:5000/register';
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
  }

  Future<void> loginUser(String username, String password) async {
    if (usernameController.text == "" ||
        passwordController.text == "" ||
        usernameController.text.length < 3 ||
        passwordController.text.length < 4) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogueBoxWidget('Enter Valid Username and Password'),
      );
    } else if (usernameController.text.length > 8) {
      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
          "\\@" +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
          "(" +
          "\\." +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
          ")+";
      RegExp regExp = new RegExp(p);

      if (!regExp.hasMatch(usernameController.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              DialogueBoxWidget('Enter Valid Username and Password'),
        );
      }
    } else {
      final url = 'http://192.168.0.100:5000/login/$username';
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
                MaterialPageRoute(
                    builder: (context) => MyHomePage('Your Post')),
                (route) => false);
          });
        }
      } catch (e) {
        throw e;
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.yellowAccent, Colors.lightBlueAccent],
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.yellowAccent, Colors.lightBlueAccent],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Image.network(
                              'https://logos-download.com/wp-content/uploads/2016/06/Bitcoin_logo_yellow.png'),
                        ),
                        Container(
                          child: TextField(
                            cursorColor: Colors.white,
                            controller: usernameController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.supervised_user_circle,
                                  color: Colors.blue,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Enter username"),
                          ),
                        ),
                        Container(
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

                            loginUser(usernameController.text,
                                passwordController.text);
                          },
                          elevation: 10,
                          child: Text('Login'),
                          color: Colors.yellowAccent,
                        ),
                        RaisedButton(
                          color: Colors.greenAccent,
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            register(usernameController.text,
                                passwordController.text);
                          },
                          child: Text('Sign Up Instead'),
                          elevation: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
