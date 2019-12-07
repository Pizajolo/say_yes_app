import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/pages/profile_page.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/utilities/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user) {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: user.profileImageUrl.isEmpty
              ? AssetImage('assets/images/default_avatar.png')
              : CachedNetworkImageProvider(user.profileImageUrl),
        ),
        title: Text(user.username),
        onTap: () => {
              if (user.id != Provider.of<UserData>(context).currentUserId)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(
                        userId: user.id,
                      ),
                    ),
                  ),
                },
            });
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                  ),
                  onPressed: _clearSearch,
                ),
                filled: true),
            onSubmitted: (input) {
              if (input.isNotEmpty) {
                setState(() {
                  _users = DatabaseService.searchUser(input);
                });
              }
            },
          ),
        ),
        body: _users == null
            ? _buildChatOverview(context)
            : FutureBuilder(
                future: _users,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text('No users found!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = User.fromDoc(snapshot.data.documents[index]);
                      return _buildUserTile(user);
                    },
                  );
                }));
  }

  Widget _buildChatOverview(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: usersRef
            .document(Provider.of<UserData>(context).currentUserId)
            .collection('chats')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index], index),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, int index) {
//    print(document['users'][index]['photoUrl']);
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: document['photoUrl'] == null
                  ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        ),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                      imageUrl: document['users'][index]['photoUrl'],
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 50.0,
                      color: Colors.grey,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        document['users'][index]['username'],
                        style: TextStyle(fontSize: 18.0),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => Chat(
//                      peerId: document.documentID,
//                      peerAvatar: document['photoUrl'],
//                    )));
        },
        color: Colors.blueAccent,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}
