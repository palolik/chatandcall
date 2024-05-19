import 'package:filechat/screens/call_screen.dart';
import 'package:flutter/material.dart';

class IncomingCallScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String callId;
  final VoidCallback stopRingtone;

  const IncomingCallScreen(
      {super.key,
      required this.data,
      required this.callId,
      required this.stopRingtone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Incoming Call',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${data['receiver_name']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "1",
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                  onPressed: () {
                    stopRingtone();
                    Navigator.pop(context);
                  },
                ),
                FloatingActionButton(
                  heroTag: "2",
                  backgroundColor: Colors.green,
                  child: Icon(Icons.call),
                  onPressed: () {
                    stopRingtone();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          data: data,
                          callId: callId,
                        ),
                      ),
                    );
                    // Handle call acceptance
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
