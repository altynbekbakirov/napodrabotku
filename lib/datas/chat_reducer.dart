import 'dart:convert';

import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:ishtapp/datas/chat.dart';

import 'RSAA.dart';

ChatState chatReducer(ChatState state, FSA action) {
  ChatState newState = state;

  switch (action.type) {
    case GET_CHAT_LIST_REQUEST:
      newState.chat_list.error = null;
      newState.chat_list.loading = true;
      newState.chat_list.data = null;
      return newState;

    case GET_CHAT_LIST_SUCCESS:
      newState.chat_list.error = null;
      newState.chat_list.loading = false;
      newState.chat_list.data = chatViewsFromJsonStr(action.payload);
      return newState;

    case GET_CHAT_LIST_FAILURE:
      newState.chat_list.error = action.payload;
      newState.chat_list.loading = false;
      newState.chat_list.data = null;
      return newState;

    case GET_MESSAGE_LIST_REQUEST:
      newState.message_list.error = null;
      newState.message_list.loading = true;
      newState.message_list.data = null;
      return newState;

    case GET_MESSAGE_LIST_SUCCESS:
      newState.message_list.error = null;
      newState.message_list.loading = false;
      newState.message_list.data = messageFromJsonStr(action.payload);
      return newState;

    case GET_MESSAGE_LIST_FAILURE:
      newState.message_list.error = action.payload;
      newState.message_list.loading = false;
      newState.message_list.data = null;
      return newState;

    default:
      return newState;
  }
}

List<ChatView> chatViewsFromJsonStr(dynamic payload) {
  Iterable jsonArray = json.decode(payload);
  return jsonArray.map((j) => ChatView.fromJson(j)).toList();
}

List<Message> messageFromJsonStr(dynamic payload) {
  Iterable jsonArray = json.decode(payload);
  return jsonArray.map((j) => Message.fromJson(j)).toList();
}
