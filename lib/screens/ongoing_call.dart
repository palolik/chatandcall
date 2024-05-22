import 'package:filechat/api/apis.dart';
import 'package:filechat/config/agora_config.dart';
import 'package:filechat/models/contact_user.dart';
import 'package:flutter/material.dart';

class OngoingCall extends StatefulWidget {
  const OngoingCall({super.key, required this.contactUser});
  final Map<String, dynamic> contactUser;

  @override
  State<OngoingCall> createState() => _OngoingCallState();
}

class _OngoingCallState extends State<OngoingCall> {
  final AgoraConfig agoraConfig = AgoraConfig();
  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  @override
  void dispose() {
    agoraConfig.leaveChannel();
    agoraConfig.destroyChannel();
    super.dispose();
  }

  Future<void> initializeAgora() async {
    await agoraConfig.initialize();
    var channelId = generateChannelId();
    await APIs.createCallInvitation(widget.contactUser, channelId);
    await agoraConfig.joinChannel(channelId);
  }

  String generateChannelId() {
    return 'channel_${DateTime.now().millisecondsSinceEpoch}_${APIs.user.uid}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Calling',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              "${widget.contactUser['name']}",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "${widget.contactUser['phone']}",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 300),
            IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red, size: 50),
              onPressed: () {
                // Handle end call
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
