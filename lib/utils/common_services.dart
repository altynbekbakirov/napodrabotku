// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSnackBar({@required BuildContext context, @required String message, @required Color backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
}
