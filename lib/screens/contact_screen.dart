import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filechat/models/contact_user.dart';
import 'package:filechat/screens/add_contacts.dart';
import 'package:filechat/screens/call_history.dart';
import 'package:filechat/screens/home_screen.dart';
import 'package:filechat/screens/ongoing_call.dart';
import 'package:filechat/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int _selectedIndex = 2;

  // Reference to Firestore collection
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  // Function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens based on the selected index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CallHistory()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BD Call'),
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
      body: FutureBuilder<QuerySnapshot>(
        future: APIs.getMyContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> data =
                    documents[index].data() as Map<String, dynamic>;
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    data['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    data['phone'],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.description,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Implement description functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          ContactUser contactUser = ContactUser(
                              name: data['name'],
                              email: data['email'],
                              phone: data['phone'],
                              uid: data['contact_uid']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      OngoingCall(contactUser: data)));
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Implement onTap functionality
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContact()),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.contact_phone),
      ),
    );
  }
}
