// import 'package:filechat/api/apis.dart';
// import 'package:filechat/screens/add_contacts.dart';
// import 'package:filechat/screens/call_history.dart';
// import 'package:filechat/screens/contact_screen.dart';
// import 'package:filechat/screens/home_screen.dart';
// import 'package:filechat/screens/profile_screen.dart';
// import 'package:filechat/widgets/navigation_bar.dart';
// import 'package:flutter/material.dart';
//
//
// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key});
//
//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }
//
// class _NavigationScreenState extends State<NavigationScreen> {
//   List<String> screenTitle = ["Home", "Contacts", "Call History"];
//   int currentPageIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           screenTitle[currentPageIndex],
//         ),
//         centerTitle: false,
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => ProfileScreen(user: APIs.me)));
//               }, icon: const Icon(Icons.account_circle_rounded))
//         ],
//       ),
//       bottomNavigationBar: BNavigationBar(
//           currentIndex: currentPageIndex,
//           onDestinationSelected: (index) {
//             setState(() {
//               currentPageIndex = index;
//             });
//           }),
//       floatingActionButton: FloatingActionButton(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => const AddContact()));
//         },
//         elevation: 1,
//         child: const Icon(Icons.add),
//       ),
//       body: <Widget>[
//         const HomeScreen(),
//         const ContactScreen(),
//         const CallHistory(),
//       ][currentPageIndex],
//     );
//   }
// }
