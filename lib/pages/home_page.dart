import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_yes_app/pages/activity_page.dart';
import 'package:say_yes_app/pages/create_event_page.dart';
import 'package:say_yes_app/pages/feed_page.dart';
import 'package:say_yes_app/pages/profile_page.dart';
import 'package:say_yes_app/pages/search_page.dart';

class HomePage extends StatefulWidget {

  final String userId;
  HomePage({this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Say YES',
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 35.0),
          )),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedPage(),
          SearchPage(),
          CreateEventPage(),
          ActivityPage(),
          ProfilePage(userId: widget.userId),
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
            });
            _pageController.animateToPage(index, duration: Duration(microseconds: 200), curve: Curves.easeIn);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 32.0)),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 32.0)),
            BottomNavigationBarItem(icon: Icon(Icons.add, size: 32.0)),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications, size: 32.0)),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: 32.0)),
          ]),
    );
  }
}
