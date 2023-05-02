import 'package:flutter/material.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  // Variables
  final bool isUserSender;
  final String body;
  final bool read;
  final DateTime date_time;

  final DateFormat formatter = DateFormat('dd-MM-yyyy H:mm');

  ChatMessage(
      {@required this.isUserSender,
      @required this.read,
      @required this.body,
      @required this.date_time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),

          /// User message
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isUserSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                /// Message container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: !isUserSender

                          /// Color for receiver
                          ? Colors.grey.withAlpha(70)

                          /// Color for sender
                          : kColorPrimary,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    body ?? "",
                    style: TextStyle(
                        fontSize: 18,
                        color: isUserSender ? Colors.white : Colors.black),
//                        textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5),

                /// Message time ago
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      formatter.format(date_time),
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            ),
          ),
          SizedBox(width: 10),

          /// Current User photo right
//          isUserSender ? _userProfilePhoto : Container(width: 0, height: 0),
        ],
      ),
    );
  }
}
