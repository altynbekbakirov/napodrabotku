import 'package:flutter/material.dart';

Widget CircleButton({
  @required Widget icon,
  @required bgColor,
  double padding
}) {

  return Container(
      padding: EdgeInsets.all(padding ?? 5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
      ),
      child: icon
  );

}