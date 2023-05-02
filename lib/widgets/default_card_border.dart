import 'package:flutter/material.dart';


/// Default Card border
RoundedRectangleBorder defaultCardBorder() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ));
}
