// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// class CallScreen extends StatefulWidget {
//   @override
//   _CallScreenState createState() => _CallScreenState();
// }
// class _CallScreenState extends State<CallScreen> {
//   late RtcEngine engine;
//   late Timer _timer;
//   /// for knowing if the current user joined
//   /// the call channel.
//   bool joined = false;
//   /// the remote user id.
//   late String remoteUid;
//   /// if microphone is opened.
//   bool openMicrophone = true;
//   /// if the speaker is enabled.
//   bool enableSpeakerphone = true;
//   /// if call sound play effect is playing.
//   bool playEffect = true;
//   /// the call document reference.
//   late DocumentReference callReference;
//   /// call time made.
//   int callTime = 0;
//   /// if the call was accepted
//   /// by the remove user.
//   bool callAccepted = false;
//   /// if callTime can be increment.
//   bool canIncrement = true;
//   void startTimer() {
//     const duration = Duration(seconds: 1);
//     _timer = Timer.periodic(duration, (Timer timer) {
//       if (mounted) {
//         if (canIncrement) {
//           setState((){
//             callTime += 1;
//           });
//         }
//       }
//     });
//   }
//   void switchMicrophone() {
//     engine?.enableLocalAudio(!openMicrophone)?.then((value) {
//       setState((){
//         openMicrophone = !openMicrophone;
//       });
//     })?.catchError((err) {
//       debugPrint("enableLocalAudio: $err");
//     });
//   }
//   void switchSpeakerphone() {
//     engine?.setEnableSpeakerphone(!enableSpeakerphone)?.then((value) {
//       setState((){
//         enableSpeakerphone = !enableSpeakerphone;
//       });
//     })?.catchError((err) {
//       debugPrint("enableSpeakerphone: $err");
//     });
//   }
//   Future<void> switchEffect() async {
//     if (playEffect) {
//       engine?.stopEffect(1)?.then((value) {
//         setState((){
//           playEffect = false;
//         });
//       })?.catchError((err) {
//         debugPrint("stopEffect $err");
//       });
//     } else {
//       engine
//           ?.playEffect(
//         1,
//         await RtcEngine.getAssetAbsolutePath(
//             "assets/sounds/house_phone_uk.mp3"),
//         -1,
//         1,
//         1,
//         100,
//         true,
//       )
//           ?.then((value) {
//         setState((){
//           playEffect = true;
//         });
//       })?.catchError((err) {
//         debugPrint("playEffect $err");
//       });
//     }
//   }
//   Future<void> initRtcEngine() async {
//     final String channelName = Uuid().v4();
//     // Create RTC client instance
//     engine = await RtcEngine.create(agoraAppId);
//     // Define event handler
//     engine.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (String channel, int uid, int elapsed) async {
//         debugPrint('joinChannelSuccess $channel $uid');
//         if (mounted) setState((){
//           joined = true;
//         });
//         callReference = await createCall(channelName);
//         switchEffect();
//         callListener = FirebaseFireStore.instance.collection("calls").doc(callReference.id).snapshots.listen((data){
//           if (!data.exists) {
//             // tell the user that the call was cancelled
//             Navigator.of(context).pop();
//             return;
//           }
//         });
//       },
//       leaveChannel: (stats) {
//         debugPrint("leaveChannel ${stats.toJson()}");
//         if (mounted) setState((){
//           joined = false;
//         });
//       },
//       userJoined: (int uid, int elapsed) {
//         debugPrint('userJoined $uid');
//         setState((){
//           remoteUid = uid;
//         });
//         switchEffect();
//         setState((){
//           if (!canIncrement) canIncrement = true;
//           callAccepted = true;
//         });
//         startTimer();
//       },
//       userOffline: (int uid, UserOfflineReason reason) {
//         debugPrint('userOffline $uid');
//         setState((){
//           remoteUid = null;
//           canIncrement = false;
//         });
//         switchEffect();
//       },
//     ));
//   }
//   var callListener;
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       // the page design
//     );
//   }
// }