import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class ChatState {
  ListChatViewState chat_list;
  ListMessageViewState message_list;

  factory ChatState.initial() => ChatState(
        chat_list: ListChatViewState.initial(),
        message_list: ListMessageViewState.initial(),
      );

  ChatState({this.chat_list, this.message_list});
}

class ListChatViewState {
  dynamic error;
  bool loading;
  List<ChatView> data;

  ListChatViewState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListChatViewState.initial() => ListChatViewState(
        error: null,
        loading: false,
        data: [],
      );
}

class ChatView {
  int user_id;
  String name;
  String avatar;
  String last_message;
  int num_of_unreads;

  ChatView(
      {this.user_id,
      this.avatar,
      this.last_message,
      this.name,
      this.num_of_unreads});

  factory ChatView.fromJson(Map<String, dynamic> json) => new ChatView(
      user_id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      last_message: json["last_message"],
      num_of_unreads: json["unread_messages"]);

  static Future<String> deleteChat(int receiver_id) async {
    final url = API_IP + API_CHAT_DELETE;
    print(url);
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'receiver_id': receiver_id}),
      );
      json.decode(response.body);
      return "OK";
    } catch (error) {
      throw error;
    }
  }
}

class ListMessageViewState {
  dynamic error;
  bool loading;
  List<Message> data;

  ListMessageViewState({
    this.error,
    this.loading,
    this.data,
  });

  factory ListMessageViewState.initial() => ListMessageViewState(
        error: null,
        loading: false,
        data: [],
      );
}

enum MessageType { FROM, TO }

class Message {
  String body;
  DateTime date_time;
  bool type;
  bool read;

  Message({this.body, this.date_time, this.type, this.read});
  static DateFormat formatter = DateFormat('yyyy-MM-dd H:m');

  factory Message.fromJson(Map<String, dynamic> json) => new Message(
      body: json["message"],
      date_time: formatter.parse(json['date_time']),
      type: json["from"],
      read: json["read"]);

  static Future<String> sendMessage(String message, int receiver_id) async {
    final url = API_IP + API_SEND_MESSAGE;
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": Prefs.getString(Prefs.TOKEN)
      };
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'message': message, 'receiver_id': receiver_id}),
      );
      json.decode(response.body);
      return "OK";
    } catch (error) {
      throw error;
    }
  }
}
