import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/pages/profile_page.dart';
import 'package:say_yes_app/services/database_service.dart';

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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(
            userId: user.id,
          ),
        ),
      ),
    );
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
            ? Center(
                child: Text('Search for user'),
              )
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
}
