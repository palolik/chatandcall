import 'package:filechat/api/apis.dart';
import 'package:filechat/config/agora_config.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.data, required this.callId});
  final Map<String, dynamic> data;
  final String callId;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraConfig agoraConfig = AgoraConfig();

  @override
  void initState() {
    initializeAgora();
    super.initState();
  }

  Future<void> initializeAgora() async {
    await agoraConfig.initialize();
    var channelId = widget.data['channelId'];
    await APIs.acceptCallInvitation(widget.callId);
    await agoraConfig.joinChannel(channelId);
  }

  @override
  void dispose() {
    APIs.doneCall(widget.callId);
    agoraConfig.leaveChannel();
    agoraConfig.destroyChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Call in Progress"),
      ),
    );
  }
}
