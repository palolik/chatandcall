import 'package:filechat/screens/contact_screen.dart';
import 'package:filechat/screens/home_screen.dart';
import 'package:filechat/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';


class CallHistory extends StatefulWidget {
  const CallHistory({super.key});

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {

 int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Check if the index corresponds to the "Settings" item
    if (index == 0) { // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    if (index == 1) { // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CallHistory()),
      );
    }
    if (index == 2) { // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContactScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return

    Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),

        title : const Text('BD Call'),
        actions: [
          // search user button
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         _isSearching = !_isSearching;
          //       });
          //     },
          //     icon: Icon(_isSearching
          //         ? CupertinoIcons.clear_circled_solid
          //         : Icons.search)),
          // more features button
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(user: APIs.me)));
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Call History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Contacts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Text('this is call history page'),
    );
  }
}
