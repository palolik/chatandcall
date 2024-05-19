import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraConfig {
  static const String appId = '79ffc2d7dbc7434da06ad1351535dc85';
  static const String token =
      '007eJxTYIi8ExdSv0D9w7kVCrs/Z3Vma217mjZx9cfpfK2npsTfmZCpwGBumZaWbJRinpKUbG5ibJKSaGCWmGJobGpoamyakmxh2r7ZPa0hkJHB4NAOFkYGCATxORnK8jOTU5MTc3IYGADFAyP+';

  late RtcEngine engine;
  int? _remoteUid;

  Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone].request();
    }
    RtcEngineContext context = RtcEngineContext(appId);
    engine = await RtcEngine.createWithContext(context);
    await engine.enableAudio();
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel $uid');
      },
      userJoined: (uid, elapsed) {
        print('userJoined $uid');
        _remoteUid = uid;
      },
      userOffline: (uid, reason) {
        print('userOffline $uid');
      },
    ));
  }

  Future<void> joinChannel(String channelName) async {
    await engine.joinChannel(token, channelName, null, 0);
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
  }

  Future<void> destroyChannel() async {
    await engine.destroy();
  }
}
