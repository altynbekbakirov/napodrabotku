import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/screens/profile_likes_screen.dart';
import 'package:ishtapp/screens/profile_visits_screen.dart';
import 'package:ishtapp/widgets/svg_icon.dart';

import 'badge.dart';
import 'default_card_border.dart';

class ProfileStatisticsCard extends StatelessWidget {
  // Variables
  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.grey[100],
      shape: defaultCardBorder(),
      child: Column(
        children: [
          ListTile(
            leading: SvgIcon("assets/icons/like.svg",
                width: 22, height: 22, color: Theme.of(context).primaryColor),
            title: Text("likeds".tr(), style: _textStyle),
            trailing: Badge(text: "125"),
            onTap: () {
              /// Go to profile likes screen ()
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileLikesScreen()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: SvgIcon("assets/icons/eye_icon.svg",
                width: 31, height: 31, color: Theme.of(context).primaryColor),
            title: Text("visit".tr(), style: _textStyle),
            trailing: Badge(text: "238"),
            onTap: () {
              /// Go to profile visits screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileVisitsScreen()));
            },
          ),
          Divider(height: 0),
          /*ListTile(
            leading: SvgIcon("assets/icons/close_icon.svg",
                width: 25, height: 25, color: Theme.of(context).primaryColor),
            title: Text("DISLIKED PROFILES", style: _textStyle),
            trailing: Badge(text: "325"),
            onTap: () {
              /// Go to disliked profile screen
              Navigator.push(context, MaterialPageRoute(
                 builder: (context) => DislikedProfilesScreen()));
            },
          ),*/
        ],
      ),
    );
  }
}
