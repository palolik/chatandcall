// import 'package:flutter/material.dart';
//
// class AppTheme {
//   static const Color primaryColor = Colors.blue;
//   static final Color shadowColor = Colors.grey.shade300;
//   static const Color bottomNavBarColor = Colors.white;
//   static final Color scaffoldColor = Colors.grey.shade100;
// }
// class BNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onDestinationSelected;
//
//   const BNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.onDestinationSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       onDestinationSelected: onDestinationSelected,
//       surfaceTintColor: AppTheme.bottomNavBarColor,
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       backgroundColor: AppTheme.bottomNavBarColor,
//       indicatorColor: AppTheme.shadowColor,
//       elevation: 4,
//       selectedIndex: currentIndex,
//       destinations: const <Widget>[
//         NavigationDestination(
//           selectedIcon: Icon(Icons.messenger_sharp),
//           icon: Badge(child: Icon(Icons.messenger_outline)),
//           label: 'Chats',
//         ),
//         NavigationDestination(
//           selectedIcon: Icon(Icons.contacts),
//           icon: Icon(Icons.contacts_outlined),
//           label: 'Contacts',
//         ),
//         NavigationDestination(
//           icon: Badge(
//             label: Text('2'),
//             child: Icon(Icons.call_sharp),
//           ),
//           label: 'Calls',
//         ),
//       ],
//     );
//   }
// }
