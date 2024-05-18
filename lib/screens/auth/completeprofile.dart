// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:geolocator/geolocator.dart';
//
// class ProfileCreation extends StatefulWidget {
//   @override
//   _ProfileCreationState createState() => _ProfileCreationState();
// }
//
// class _ProfileCreationState extends State<ProfileCreation> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   String _firstname = '';
//   String _lastname = '';
//   String _email = ''; // Assuming email is already retrieved
//   String _selectedGender = '';
//   String _city = '';
//   String _address = '';
//   String _profilePictureURL = ''; // To store the profile picture URL
//   String _latitude = '';
//   String _longitude = '';
//   Timer? _timer;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance
//   final ImagePicker _picker = ImagePicker(); // Image picker instance
//
//   @override
//   void initState() {
//     super.initState();
//     // Start the timer when the widget is initialized
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _getCurrentLocation();
//     });
//   }
//
//   @override
//   void dispose() {
//     // Dispose the timer when the widget is disposed
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // Ask to enable GPS service
//         throw Exception('Location services are disabled.');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           // Handle permission denied cases
//           throw Exception('Location permissions are denied.');
//         }
//       }
//
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//       setState(() {
//         _latitude = position.latitude.toString();
//         _longitude = position.longitude.toString();
//       });
//
//       // Update location data on Firebase
//       try {
//         final user = await _auth.currentUser!;
//         await _firestore.collection('users').doc(user.uid).update({
//           'latitude': _latitude,
//           'longitude': _longitude,
//         });
//       } catch (e) {
//         print('Error updating location data on Firebase: $e');
//       }
//     } catch (e) {
//       print('Error getting current location: $e');
//
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       // If image is picked
//       File imageFile = File(pickedImage.path);
//       await _uploadImage(imageFile);
//     }
//   }
//
//   Future<void> _uploadImage(File imageFile) async {
//     try {
//       final user = await _auth.currentUser!;
//       String fileName = 'profile_${user.uid}.jpg'; // Unique file name for the image
//       Reference reference = _storage.ref().child('propics/$fileName');
//       UploadTask uploadTask = reference.putFile(imageFile);
//       TaskSnapshot storageTaskSnapshot = await uploadTask;
//       String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
//       setState(() {
//         _profilePictureURL = imageURL;
//       });
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   Future<void> _createProfile() async {
//     if (!_formKey.currentState!.validate()) return; // Exit if invalid
//
//     _formKey.currentState!.save();
//
//     try {
//       final user = await _auth.currentUser!; // Get current user
//       await _firestore.collection('users').doc(user.uid).set({
//         'profiletype': 'users',
//         'firstName': _firstname,
//         'lastName': _lastname,
//         'email': user.email,
//         'uid': user.uid,
//         'gender': _selectedGender,
//         'city': _city,
//         'address': _address,
//         'profilePictureURL': _profilePictureURL,
//         'latitude': _latitude, // Store latitude
//         'longitude': _longitude, // Store longitude
//       });
//       // Handle profile creation success (e.g., navigate to a different screen)
//       print('Profile created successfully!');
//     } on FirebaseAuthException catch (e) {
//       // Handle Firebase Auth errors
//       print('Error creating profile: ${e.code}');
//     } catch (e) {
//       // Handle other errors
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               SizedBox(height: 20.0),
//               GestureDetector(
//                 onTap: _pickImage, // Open image picker on tap
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _profilePictureURL.isNotEmpty
//                       ? NetworkImage(_profilePictureURL) // Display picked image if available
//                       : null,
//                   child: _profilePictureURL.isEmpty
//                       ? Icon(Icons.add_a_photo, size: 50) // Placeholder icon if no image
//                       : null,
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'First Name',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) => setState(() => _firstname = value!),
//                     ),
//                   ),
//                   SizedBox(width: 10.0), // Add spacing between text fields (optional)
//                   Expanded(
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Last Name',
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter your name';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) => setState(() => _lastname = value!),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.0),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixIcon: Icon(Icons.phone),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   // Add your specific phone number format validation here (optional)
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => setState(() => _email = value!),
//               ),
//               SizedBox(height: 20.0),
//               Row(
//                 children: [
//                   Text('Gender:  '),
//                   Text('Male'),
//                   Radio<String>(
//                     value: 'male',
//                     groupValue: _selectedGender, // Store the selected value
//                     onChanged: (value) => setState(() => _selectedGender = value!),
//                   ),
//                   Text('Female'),
//                   Radio<String>(
//                     value: 'female',
//                     groupValue: _selectedGender,
//                     onChanged: (value) => setState(() => _selectedGender = value!),
//                   ),
//                   // You can add more options here (e.g., Non-binary)
//                 ],
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'City',
//                 ),
//                 maxLines: 1,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your city';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => setState(() => _city = value!), // Save city value
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Address',
//                 ),
//                 maxLines: 2,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter your address';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => setState(() => _address = value!), // Save address value
//               ),
//               Text(
//                 'Latitude: $_latitude, Longitude: $_longitude',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20.0),
//               GestureDetector(
//                 onTap: _createProfile, // Use the _createProfile function
//                 child: Container(
//                   color: Colors.indigo,
//                   width: double.infinity,
//                   height: 50,
//                   alignment: Alignment.center,
//                   child: Text('Update Profile', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               Text('Change Password'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
