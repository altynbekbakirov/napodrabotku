import 'package:flutter/material.dart';

void showScaffoldMessage({
  @required BuildContext context,
  @required GlobalKey<ScaffoldState> scaffoldkey,
  @required String message
}) {
  scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(message,
        style: TextStyle(fontSize: 18)),
    backgroundColor: Theme.of(context).primaryColor,
  ));
}
