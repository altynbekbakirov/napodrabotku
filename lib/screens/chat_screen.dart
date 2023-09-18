import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/chat.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/widgets/chat_message.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:convert';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  /// Get user object
  final int user_id;
  String name;
  String vacancy;
  int vacancy_id;
  String avatar;

  ChatScreen({@required this.user_id, this.name, this.vacancy_id, this.vacancy, this.avatar});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void handleInitialBuild(MessageListProps props) {
    props.getMessageList(widget.user_id, widget.vacancy_id);
  }

  // Variables
  final _textController = TextEditingController();
  bool _isComposing = false;

  final DateFormat formatter = DateFormat('yyyy-MM-dd H:m');

  ScrollController controller = new ScrollController();

  PusherClient pusher;
  Channel channel;

  // void bindEventPusher() async {
  //   channel.bind('new-message-sent', (PusherEvent event) {
  //     var data = json.decode(event.data);
  //     print("New message sent event " + event.data.toString());
  //
  //     if(data['user_id'] - Prefs.getInt(Prefs.USER_ID) == 0 && data['vacancy_id'] - widget.vacancy_id == 0){
  //       setState(() {
  //         StoreProvider.of<AppState>(context).dispatch(getChatList());
  //         StoreProvider.of<AppState>(context).dispatch(getNumberOfUnreadMessages());
  //         StoreProvider.of<AppState>(context).dispatch(getMessageList(data['sender_id'], data['vacancy_id']));
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // PusherClient pusher = PusherClient(
    //   '73e14d3cf78debd02655',
    //   PusherOptions(
    //       cluster: 'ap2'
    //   ),
    //   autoConnect: true,
    //   enableLogging: true,
    // );
    //
    // channel = pusher.subscribe("chat");
    //
    // pusher.onConnectionStateChange((state) {
    //   print("previousState: ${state.previousState}, currentState: ${state.currentState}");
    // });
    //
    // pusher.onConnectionError((error) {
    //   print("error: ${error.message}");
    // });
    //
    // bindEventPusher();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MessageListProps>(
      converter: (store) => mapStateToMessageProps(store, widget.user_id, widget.vacancy_id),
      onInitialBuild: (props) => this.handleInitialBuild(props),
      builder: (context, props) {
        List<Message> data = props.list.data;
        bool loading = props.list.loading;

        Widget body;
        if (loading) {
          body = Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {
          body = Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (context, index) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          controller.jumpTo(controller.position.maxScrollExtent);
                        });
                        return ChatMessage(
                          isUserSender: data[index].type,
                          body: data[index].body,
                          date_time: data[index].date_time,
                          read: data[index].read,
                        );
                      }
                  ),
                ),
              ),
              Container(
                color: Colors.grey.withAlpha(50),
                child: ListTile(
                    title: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: "write".tr(), border: InputBorder.none),
                      onChanged: (text) {
                        setState(() {
                          _isComposing = text.isNotEmpty;
                        });
                      },
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.send,
                            color: _isComposing
                                ? Theme.of(context).primaryColor
                                : Colors.grey),
                        onPressed: _isComposing
                            ? () async {
                                Message.sendMessage(_textController.text, widget.user_id, widget.vacancy_id);
                                data.add(Message(
                                    body: _textController.text,
                                    date_time: DateTime.now(),
                                    type: true,
                                    read: true)
                                );
                                _textController.clear();
                                setState(() => _isComposing = false);
                              }
                            : null
                    )
                ),
              ),
            ],
          );
        }

        return Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: (){
                    StoreProvider.of<AppState>(context).dispatch(getChatList());
                    StoreProvider.of<AppState>(context).dispatch(getNumberOfUnreadMessages());
                    Navigator.pop(context,true);
                  }
              ),
              title: GestureDetector(
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 0),
                  leading: CircleAvatar(
                    backgroundImage: widget.avatar != null
                        ? NetworkImage(SERVER_IP + widget.avatar, headers: {
                            "Authorization": Prefs.getString(Prefs.TOKEN)
                          })
                        : AssetImage('assets/images/default-user.jpg'),
                  ),
                  title: Text(
                      widget.vacancy.length >= 10 ?
                      widget.name + ' (' + widget.vacancy.replaceRange(10, widget.vacancy.length, '...') + ')' :
                      widget.name + ' (' + widget.vacancy + ')',
                      style: TextStyle(fontSize: 16)
                  ),
                ),
                onTap: () {
                },
              ),
              actions: <Widget>[
                /// Actions list
                PopupMenuButton<String>(
                  initialValue: "",
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    /// Delete Chat
                    PopupMenuItem(
                        value: "delete_chat",
                        child: Row(
                          children: <Widget>[
                            SvgIcon("assets/icons/trash_icon.svg",
                                width: 20,
                                height: 20,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 5),
                            Text("delete_conversation".tr()),
                          ],
                        )),
                  ],
                  onSelected: (val) {
                    if (val == 'delete_chat') {
                      print(val);
                      ChatView.deleteChat(widget.user_id);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            body: body);
      },
    );
  }
}

class MessageListProps {
  final Function getMessageList;
  final ListMessageViewState list;

  MessageListProps({
    this.getMessageList,
    this.list,
  });
}

MessageListProps mapStateToMessageProps(Store<AppState> store, int receiver_id, int vacancy_id) {
  return MessageListProps(
    list: store.state.chat.message_list,
    getMessageList: (int receiver_id, int vacancy_id) =>
        store.dispatch(getMessageList(receiver_id, vacancy_id)),
  );
}
