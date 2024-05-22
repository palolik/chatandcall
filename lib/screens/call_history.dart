import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filechat/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import 'contact_screen.dart';
import 'home_screen.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  int _selectedIndex = 1;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<List<DocumentSnapshot>> _getCallHistory() async {
    final calls = await FirebaseFirestore.instance
        .collection('calls')
        .where('sender', isEqualTo: _user!.uid)
        .get();

    final receiverCalls = await FirebaseFirestore.instance
        .collection('calls')
        .where('receiver', isEqualTo: _user!.uid)
        .get();

    return [...calls.docs, ...receiverCalls.docs];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContactScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title:  Image.asset('assets/images/logo.jpg'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: APIs.me),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_calls_sharp),
            label: 'Call History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_sharp),
            label: 'Contacts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: FutureBuilder(
        future: _getCallHistory(),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final calls = snapshot.data!;
          if (calls.isEmpty) {
            return Center(child: Text('No call history found.'));
          }
          return ListView.builder(
            itemCount: calls.length,
            itemBuilder: (context, index) {
              final call = calls[index].data() as Map<String, dynamic>;
              final callTime = (call['timestamp'] as Timestamp).toDate();
              final formattedCallTime =
                  "${callTime.year}-${callTime.month}-${callTime.day} ${callTime.hour}:${callTime.minute.toString().padLeft(2, '0')}";

              IconData iconData;
              Color iconColor;
              switch (call['status']) {
                case 'COMPLETED':
                  iconData = Icons.check_circle;
                  iconColor = Colors.green;
                  break;
                case 'MISSED':
                  iconData = Icons.cancel;
                  iconColor = Colors.red;
                  break;
                default:
                  iconData = Icons.info;
                  iconColor = Colors.grey;
              }

              return ListTile(
                leading: Icon(iconData, color: iconColor),
                title: Text(call['receiver_name']),
                subtitle: Row(
                  children: [
                    Text(call['status']),
                    SizedBox(width: 10),
                    Text(formattedCallTime),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
