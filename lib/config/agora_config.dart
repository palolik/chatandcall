import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraConfig {
  static const String appId = '820678d27dd349c2a7c758d1677c18d6';
  // static const String token =
  //     '007eJxTYJimt+N7ysZu9xl2drZON9TbXCa+8l+36mQfR2+hWYU8Q4sCg7llWlqyUYp5SlKyuYmxSUqigVliiqGxqaGpsWlKsoXpPX6vtIZARobU8hQmRgYIBPE5GJITc3JKUotLGBgAgnofpA==';

  late RtcEngine engine;
  int? _remoteUid;

  Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone].request();
    }
    print("Agora Intialized................................");
    RtcEngineContext context = RtcEngineContext(appId);
    engine = await RtcEngine.createWithContext(context);
    await engine.enableAudio();
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('###################joinChannelSuccess $channel $uid');
      },
      requestToken: () {},
      userJoined: (uid, elapsed) {
        print('@@@@@@@@@@@@@@@@@@@@@userJoined $uid');
        _remoteUid = uid;
      },
      userOffline: (uid, reason) {
        print('***************************userOffline $uid');
      },
      error: (err) {
        print("!!!!!!!!!!!!!!!!!!!!!!!!${err.index}" + err.name);
      },
      apiCallExecuted: (error, api, result) {
        print("))))))))))))))))");
        print(error.name);
        print(api);
        print(result);
      },
    ));
  }


  Future<void> joinChannel(String channelName) async {
    await engine.joinChannel(null, channelName, null, 0);
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
  }

  Future<void> destroyChannel() async {
    await engine.destroy();
  }
}
