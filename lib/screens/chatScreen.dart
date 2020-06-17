import 'package:createTask/provider/messagePro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/alluserprovider.dart';
import '../widget/chatbuilder.dart';

class ChatScreen extends StatefulWidget {
  final String receiver;
  ChatScreen(this.receiver);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sender = Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(child: ChatBuilder(widget.receiver, sender)),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Send a message"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: RaisedButton.icon(
                  color: Colors.white,
                  onPressed: () {
                    if (textController.text.isEmpty) {
                      return;
                    } else {
                      Provider.of<MessagePro>(context, listen: false)
                          .sendMessage(
                              widget.receiver, textController.text, sender);
                      textController.clear();
                    }
                  },
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
