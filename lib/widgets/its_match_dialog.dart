//import 'package:flutter/material.dart';
//import 'package:ishtapp/datas/user_model.dart';
//import 'package:ishtapp/screens/chat_screen.dart';
//import 'package:swipe_stack/swipe_stack.dart';
//
//class ItsMatchDialog extends StatelessWidget {
//
//  // Variables
//  final GlobalKey<SwipeStackState> swipeKey;
//  final User matchedUser;
//
//  ItsMatchDialog({@required this.swipeKey, @required this.matchedUser});
//
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      color: Colors.black.withOpacity(.55),
//      child: SingleChildScrollView(
//        child: Container(
//          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              /// Matched User image
//              CircleAvatar(
//                radius: 75,
//                backgroundColor: Theme.of(context).primaryColor,
//                backgroundImage: AssetImage(matchedUser.userPhotoLink),
//              ),
//              SizedBox(height: 10),
//
//              /// Matched User first name
//              Text(matchedUser.userFullname.split(",")[0], style: TextStyle(
//                fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold
//              )),
//              SizedBox(height: 10),
//
//              Text("Likes you too!", style: TextStyle(
//                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold
//              )),
//              SizedBox(height: 10),
//
//              Text("You and ${matchedUser.userFullname.split(" ")[0]} liked each other!",
//                style: TextStyle(fontSize: 18, color: Colors.grey)),
//              SizedBox(height: 10),
//
//              /// Send a message button
//              SizedBox(
//                height: 47,
//                width: double.maxFinite,
//                child: RaisedButton(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(25),
//                    ),
//                    color: Theme.of(context).primaryColor,
//                    textColor: Colors.white,
//                    child: Text("Send a message",
//                        style: TextStyle(fontSize: 18)),
//                    onPressed: () {
//                      /// Go to chat screen
//                      Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => ChatScreen(user: matchedUser)));
//              })),
//              SizedBox(height: 20),
//
//              /// Keep swiping button
//              SizedBox(
//                height: 45,
//                width: double.maxFinite,
//                child: OutlineButton(
//                    borderSide: BorderSide(
//                        color: Theme.of(context).primaryColor, width: 2),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(25),
//                    ),
//                    color: Theme.of(context).primaryColor,
//                    textColor: Colors.white,
//                    child:
//                        Text("keep passing", style: TextStyle(fontSize: 18)),
//                    onPressed: () {
//                      /// Close dialog
//                      Navigator.of(context).pop();
//                      /// Swipe right
//                      swipeKey.currentState.swipeRight();
//                })),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
