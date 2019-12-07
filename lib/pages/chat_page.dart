import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final List receivers;
  final Map writer;

  ChatPage({this.chatId, this.receivers, this.writer});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading;
  var listMessage;
  String id;
  String _title = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  @override
  void initState() {
    for(Map receiver in widget.receivers){
      _title = _title + receiver['username'] + ' ';
    }
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_title, style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
    );
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      DatabaseService.sendMessage(DateTime.now(), widget.receivers, content, widget.writer, widget.chatId, Uuid().v4());
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['writer']['id'] == Provider.of<UserData>(context).currentUserId) {
      // Right (my message)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
        Container(
          child: Text(
            document['text'],
            style: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(
              color: Colors.blueAccent, borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              bottom: 10.0, right: 10.0),
        )
      ]);
    } else {
      // Left (peer message)
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      document['text'],
                      style: TextStyle(color: Colors.black),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  )
                ],
              ),
            ],
          )),
        ],
      );
    }
  }


  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
            top: new BorderSide(color: Colors.black12, width: 1.0),
          ),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => onSendMessage(textEditingController.text),
                  color: Colors.blueAccent,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('chats')
            .document(widget.chatId)
            .collection('messages')
            .orderBy('date', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }
}
