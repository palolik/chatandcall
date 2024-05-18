import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String _profiletype = 'userprofile';
  String _docname = 'users'; // Assuming the collection name is 'users'
  String _firstname = '';
  String _lastname = '';
  String _email = '';
  String _selectedGender = '';
  String _city = '';
  String _address = '';
  String _profilePictureURL = '';
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch profile data from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection(_docname).doc(user.uid).get();
        setState(() {
          _firstname = snapshot['firstName'];
          _lastname = snapshot['lastName'];
          _email = snapshot['email'];
          _selectedGender = snapshot['gender'];
          _city = snapshot['city'];
          _address = snapshot['address'];
          _profilePictureURL = snapshot['profilePictureURL'];
          _latitude = snapshot['latitude'];
          _longitude = snapshot['longitude'];
        });
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profilePictureURL.isNotEmpty
                  ? NetworkImage(_profilePictureURL)
                  : null,
              child: _profilePictureURL.isEmpty
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 20.0),
            Text(
              'First Name: $_firstname',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Last Name: $_lastname',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Gender: $_selectedGender',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'City: $_city',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Address: $_address',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Latitude: $_latitude',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Longitude: $_longitude',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
