import 'package:flutter/material.dart';
class CallerScreen extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const CallerScreen({Key? key, required this.onAccept, required this.onReject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Incoming Call...'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onAccept,
            child: Text('Accept'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onReject,
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }
}