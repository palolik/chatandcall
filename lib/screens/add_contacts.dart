// import 'package:filechat/api/apis.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AddContact extends StatefulWidget {
//   const AddContact({Key? key}) : super(key: key);
//
//   @override
//   State<AddContact> createState() => _AddContactState();
// }
//
// class _AddContactState extends State<AddContact> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//
//   // Reference to Firestore collection
//   final userRef = FirebaseFirestore.instance.collection('users');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Contact'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Mobile Number(use country codes too)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Perform the action when the button is pressed
//                 _submitContact();
//               },
//               child: const Text('Submit new Contact'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Function to handle submission of the new contact
//   void _submitContact() async {
//     try {
//       if (await APIs.getSelfEmail() == _emailController.value.text) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('You are already using this email.'),
//           ),
//         );
//       }
//       final contactId = await APIs.getContactId(_emailController.value.text);
//       if (contactId.docs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//                 'The user is not available on this app. You can send invite to join the app.'),
//           ),
//         );
//         return;
//       }
//       // Get the current user's UID
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//
//       // Check if UID is available
//       if (uid != null) {
//         // Add contact data to Firestore
//         await userRef.doc(uid).collection("contacts").add({
//           'name': _nameController.text,
//           'email': _emailController.text,
//           'phone': _phoneController.text,
//           'myuid': uid,
//           'contact_uid': contactId.docs[0].id
//         });
//
//         // Clear text fields after submission
//         _nameController.clear();
//         _emailController.clear();
//         _phoneController.clear();
//
//         // Show a success message or navigate to another screen
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Contact added successfully!'),
//           ),
//         );
//       } else {
//         // Show an error message if UID is not available
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User not authenticated!'),
//           ),
//         );
//       }
//     } catch (e) {
//       // Show an error message if submission fails
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to add contact. Please try again!'),
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _nameController = TextEditingController();
  // TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // Reference to Firestore collection
  final CollectionReference myContacts =
  FirebaseFirestore.instance.collection('mycontacts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // TextField(
            //   controller: _emailController,
            //   decoration: const InputDecoration(
            //     labelText: 'Email',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number(use country codes too)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Perform the action when the button is pressed
                _submitContact();
              },
              child: const Text('Submit new Contact'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle submission of the new contact
  void _submitContact() async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      // Check if UID is available
      if (uid != null) {
        // Add contact data to Firestore
        await myContacts.add({
          'name': _nameController.text,
          // 'email': _emailController.text,
          'phone': _phoneController.text,
          'myuid': uid,
        });

        // Clear text fields after submission
        _nameController.clear();
        // _emailController.clear();
        _phoneController.clear();

        // Show a success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact added successfully!'),
          ),
        );
      } else {
        // Show an error message if UID is not available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated!'),
          ),
        );
      }
    } catch (e) {
      // Show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add contact. Please try again!'),
        ),
      );
    }
  }
}
