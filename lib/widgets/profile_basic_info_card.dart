import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/screens/edit_profile_screen.dart';
import 'package:ishtapp/screens/profile_screen.dart';
import 'package:ishtapp/widgets/svg_icon.dart';

import 'default_card_border.dart';

class ProfileBasicInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 4.0,
      shape: defaultCardBorder(),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile image
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40,
                    backgroundImage:
                        NetworkImage(API_IP + API_GET_PROFILE_IMAGE, headers: {
                      "Authorization": Prefs.getString(Prefs.TOKEN)
                    }),
                  ),
                ),

                SizedBox(width: 10),

                /// Profile details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UlutSoft",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),

                    /// Location
                    Row(
                      children: [
                        SvgIcon("assets/icons/location_point_icon.svg",
                            color: Colors.white),
                        SizedBox(width: 5),
                        Text("Бишкек ул. Чехова 28",
                            style: TextStyle(color: Colors.white))
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 30,
                  child: OutlineButton.icon(
                      borderSide: BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      icon: Icon(Icons.remove_red_eye),
                      label: Text("cv".tr(), style: TextStyle(fontSize: 13)),
                      textColor: Colors.white,
                      onPressed: () {
                        /// Go to profile screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
//                            user: currentUserDemo
                                    )));
                      }),
                ),
                SizedBox(
                  height: 35,
                  child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      icon: Icon(Icons.edit),
                      textColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                      label: Text("profile".tr(), style: TextStyle(fontSize: 13)),
                      onPressed: () {
                        /// Go to edit profile screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
