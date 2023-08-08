import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/screens/home_screen.dart';
import 'package:redux/redux.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/chat.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/screens/chat_screen.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/badge.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/routes/routes.dart';
import 'dart:async';

class ConversationsTab extends StatefulWidget {
  @override
  _ConversationsTabState createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {
  void handleInitialBuild(ChatListProps props) {
    props.getChatList();
  }

  @override
  Widget build(BuildContext context) {
    if (Prefs.getString(Prefs.TOKEN) == "null" ||
        Prefs.getString(Prefs.TOKEN) == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "you_cant_see_chats_please_sign_in".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: kColorPrimary, fontSize: 20),
              ),
            ),
            CustomButton(
                text: "sign_in".tr(),
                textColor: kColorWhite,
                color: kColorPrimary,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushNamed(context, Routes.select_mode);
                })
          ],
        ),
      );
    } else {
      return StoreConnector<AppState, ChatListProps>(
        converter: (store) => mapStateToChatProps(store),
        onInitialBuild: (props) => this.handleInitialBuild(props),
        builder: (context, props) {
          List<ChatView> data = props.list.data;
          bool loading = props.list.loading;

          Widget body;
          if (loading) {
            body = Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
              ),
            );
          } else {
            body = data != null && data.length > 0
                ? Column(
                    children: [
                      /// Conversations
                      Expanded(
                          child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(height: 10),
                        itemCount: data.length,
                        itemBuilder: ((context, index) {
                          /// Get user object
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: data[index].avatar != null
                                    ? NetworkImage(
                                        SERVER_IP + data[index].avatar,
                                        headers: {
                                            "Authorization":
                                                Prefs.getString(Prefs.TOKEN)
                                          })
                                    : AssetImage(
                                        'assets/images/default-user.jpg'),
                              ),
                              title: Text(
                                  data[index].vacancy.length >= 10 ?
                                  data[index].name +
                                      ' (' +
                                      data[index].vacancy.replaceRange(10, data[index].vacancy.length, '...') +
                                      ')' :
                                  data[index].name +
                                      ' (' +
                                      data[index].vacancy +
                                      ')',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black
                                  )
                              ),
                              subtitle: Text(data[index].last_message),
                              trailing: data[index].num_of_unreads > 0
                                  ? Badge(text: data[index].num_of_unreads.toString())
                                  : null,
                              onTap: () {
                                if(Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) > 0){
                                  if(data[index].num_of_unreads > Prefs.getInt(Prefs.NEW_MESSAGES_COUNT)){
                                    Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, 0 );
                                  } else {
                                    Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, Prefs.getInt(Prefs.NEW_MESSAGES_COUNT) - data[index].num_of_unreads);
                                  }
                                }
                                // Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, 0);

                                StoreProvider.of<AppState>(context).dispatch(getChatList());
                                StoreProvider.of<AppState>(context).dispatch(getNumberOfUnreadMessages());

                                /// Go to chat screen
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        user_id: data[index].user_id,
                                        name: data[index].name,
                                        vacancy_id: data[index].vacancy_id,
                                        vacancy: data[index].vacancy,
                                        avatar: data[index].avatar
                                    )
                                ));
                              },
                            ),
                          );
                        }),
                      )),
                    ],
                  )
                : Prefs.getString(Prefs.ROUTE) == "COMPANY"
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.1),
                            child: Text(
                              "empty".tr(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: kColorPrimary, fontSize: 20),
                            ),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.1),
                            child: Text(
                              "chat_function_is_not_available".tr(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: kColorPrimary, fontSize: 20),
                            ),
                          )
                        ],
                      );
          }

          return body;
        },
      );
    }
  }
}

class ChatListProps {
  final Function getChatList;
  final ListChatViewState list;

  ChatListProps({
    this.getChatList,
    this.list,
  });
}

ChatListProps mapStateToChatProps(Store<AppState> store) {
  return ChatListProps(
    list: store.state.chat.chat_list,
    getChatList: () => store.dispatch(getChatList()),
  );
}
