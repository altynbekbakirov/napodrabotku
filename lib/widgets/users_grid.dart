import 'package:flutter/material.dart';

class UsersGrid extends StatelessWidget {

  // Variables
  final List<Widget> children;

  UsersGrid({@required this.children});

  @override
  Widget build(BuildContext context) {
    return children.length>0?GridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      childAspectRatio: 2 / 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 4,
      children: children
  ):Container();
 } 
}
