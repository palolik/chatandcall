import 'package:agora_app/config.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCall extends StatefulWidget {
  const AudioCall({Key? key}) : super(key: key);

  @override
  _AudioCallState createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  int uid = 0; // uid of the local user
  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  bool _isIncomingCall = false; // Indicates if there is an incoming call

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Call'),
          centerTitle: true,
        ),
        body: _isIncomingCall
            ? CallerScreen(onAccept: _onCallAccepted, onReject: _onCallRejected)
            : _mainScreen(),
      ),
    );
  }

  Widget _mainScreen() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        // Status text
        Container(height: 40, child: Center(child: _status())),
        // Button Row
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text("Join"),
                onPressed: () => {join()},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text("Leave"),
                onPressed: () => {leave()},
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text("Simulate Incoming Call"),
          onPressed: () => {setState(() => _isIncomingCall = true)},
        ),
      ],
    );
  }

  Widget _status() {
    String statusText;

    if (!_isJoined)
      statusText = 'Join a channel';
    else if (_remoteUid == null)
      statusText = 'Waiting for a remote user to join...';
    else
      statusText = 'Connected to remote user, uid:$_remoteUid';

    return Text(statusText);
  }

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: Config.appId));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: Config.token,
      channelId: Config.channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() async {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    await agoraEngine.leaveChannel();
  }

  void _onCallAccepted() {
    setState(() {
      _isIncomingCall = false;
    });
    join();
  }

  void _onCallRejected() {
    setState(() {
      _isIncomingCall = false;
    });
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }
}

class CallerScreen extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const CallerScreen({Key? key, required this.onAccept, required this.onReject})
      : super(key: key);

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
