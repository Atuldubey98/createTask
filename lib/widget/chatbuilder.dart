import 'dart:async';

import 'package:createTask/provider/messagePro.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatBuilder extends StatefulWidget {
  final String receiver;
  final String username;
  ChatBuilder(this.receiver, this.username);

  @override
  _ChatBuilderState createState() => _ChatBuilderState();
}

class _ChatBuilderState extends State<ChatBuilder> {
  Timer _time;

  @override
  void didChangeDependencies() {
    _time = new Timer.periodic(Duration(milliseconds: 100), (_) {
      Provider.of<MessagePro>(context, listen: false)
          .fetchPost(widget.receiver, widget.username);
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _time.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagePro>(
      child: Center(
        child: Text('Your are Lonely'),
      ),
      builder: (context, message, child) => message.list.length <= 0
          ? child
          : ListView.builder(
              itemCount: message.list.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message.list[index].message,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                );
              }),
    );
  }
}
