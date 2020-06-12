import 'package:createTask/screens/auth.dart';
import 'package:flutter/material.dart';

class DialogueBoxWidget extends StatelessWidget {
  final String data;
  DialogueBoxWidget(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: Text(data),
        contentPadding: EdgeInsets.all(12),
        actions: <Widget>[
          MaterialButton(
            child: Text("Ok"),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (route) => false),
          )
        ],
      ),
    );
  }
}
