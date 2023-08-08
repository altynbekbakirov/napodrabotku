// import 'dart:async';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_pusher/pusher.dart';
// import 'package:ishtapp/datas/pref_manager.dart';
//
// const String APP_KEY = '73e14d3cf78debd02655';
// const String PUSHER_CLUSTER = 'ap2';
//
// class PusherService {
//   Event lastEvent;
//   String lastConnectionState;
//   Channel channel;
//
//   Future<void> initPusher() async {
//     try {
//       await Pusher.init(APP_KEY, PusherOptions(cluster: PUSHER_CLUSTER), enableLogging: true);
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }
//
//   void connectPusher() {
//     Pusher.connect(
//         onConnectionStateChange: (ConnectionStateChange connectionState) async {
//           lastConnectionState = connectionState.currentState;
//         }, onError: (ConnectionError e) {
//       print("Error: ${e.message}");
//     });
//   }
//
//   Future<void> subscribePusher(String channelName) async {
//     channel = await Pusher.subscribe(channelName);
//   }
//
//   void unSubscribePusher(String channelName) {
//     Pusher.unsubscribe(channelName);
//   }
//
//   StreamController<String> _eventData = StreamController<String>();
//   Sink get _inEventData => _eventData.sink;
//   Stream get eventStream => _eventData.stream;
//
//   void bindEvent(String eventName) {
//     channel.bind(eventName, (last) {
//       final String data = last.data;
//       _inEventData.add(data);
//
//       if(Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) != null){
//         Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) +1);
//       } else{
//         Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, 0);
//       }
//     });
//   }
//
//   void unbindEvent(String eventName) {
//     channel.unbind(eventName);
//     _eventData.close();
//   }
//
//   Future<void> firePusher(String channelName, String eventName) async {
//     await initPusher();
//     connectPusher();
//     await subscribePusher(channelName);
//     bindEvent(eventName);
//   }
// }