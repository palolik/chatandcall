import 'dart:async';
import 'dart:developer';

import 'package:filechat/screens/call_history.dart';
import 'package:filechat/screens/call_screen.dart';
import 'package:filechat/screens/contact_screen.dart';
import 'package:filechat/screens/incoming_call.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';
import 'profile_screen.dart';

// home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  static const platform = MethodChannel('com.example.filechat/ringtone');
  Timer? _timer;
  // Index for the currently selected bottom navigation bar item
  int _selectedIndex = 0;
// Function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Check if the index corresponds to the "Settings" item
    if (index == 0) {
      // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    if (index == 1) {
      // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CallHistory()),
      );
    }
    if (index == 2) {
      // Index 2 corresponds to the "Settings" item
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContactScreen()),
      );
    }
  }

  // Define the navigation items
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Call History'),
    Text('Contacts'),
  ];

  Future<void> _playRingtone() async {
    try {
      _startTimer();
      await platform.invokeMethod('playRingtone');
    } on PlatformException catch (e) {
      print("Failed to play ringtone: '${e.message}'.");
    }
  }

  Future<void> _stopRingtone() async {
    try {
      await platform.invokeMethod('stopRingtone');
    } on PlatformException catch (e) {
      print("Failed to stop ringtone: '${e.message}'.");
    }
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 30), () {
      _stopRingtone();
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data['type'] == "CALL") {
        _playRingtone();
        showCallNotification(flutterLocalNotificationsPlugin, message);
        print("dataaaaaaaaaaaa: ${message.data['call_id']}");
        String callId = message.data['call_id'];
        APIs.getIncomingCalls(callId).listen((event) async {
          if (event.exists && (event.data()!['status'] == "ONGOING") ||
              event.data()!['status'] == "MISSED") {
            _stopRingtone();
          }
        });
      } else {
        showChatNotification(flutterLocalNotificationsPlugin, message);
      }
    });

    APIs.getSelfInfo();

    // for updating user active status according to lifecycle events
    // resume -- active or online
    // pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopRingtone();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when a tap is detected on the screen
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: !_isSearching,
        onPopInvoked: (_) async {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          // app bar
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me)));
                },
                icon: const Icon(Icons.home_outlined)),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    // when search text changes then updated search list
                    onChanged: (val) {
                      // search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                :  Image.asset('assets/images/logo.jpg'),
            actions: [
              // search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              // more features button
              // IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (_) => ProfileScreen(user: APIs.me)));
              //     },
              //     icon: const Icon(Icons.more_vert))
            ],
          ),
          // bottom navigation bar
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
          // floating button to add a new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(Icons.add_comment_rounded)),
          ),
          // body
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            // get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                // if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    // get only those users whose ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());
                        // if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Connections Found!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding a new chat user
  void _addChatUserDialog() {
    String phone = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              // title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),
              // content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => phone = value,
                decoration: InputDecoration(
                    hintText: 'phone number',
                    prefixIcon: const Icon(Icons.phone_iphone, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              // actions
              actions: [
                // cancel button
                MaterialButton(
                    onPressed: () {
                      // hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),
                // add button
                MaterialButton(
                    onPressed: () async {
                      // hide alert dialog
                      Navigator.pop(context);
                      if (phone.isNotEmpty) {
                        await APIs.addChatUser(phone).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }

  // Function to handle bottom navigation item selection
}
