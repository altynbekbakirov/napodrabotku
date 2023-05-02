import 'package:flutter/material.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'default_card_border.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/screens/chat_screen.dart';

class UserCard extends StatelessWidget {
  /// User object
  final Users user;

  /// Screen to be checked
  final String page;
  final int index;

  /// Swiper position
  final SwiperPosition position;

  UserCard({this.page, this.position, @required this.user, this.index});

  void _showDialog(context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'.tr()),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: index == 0
          ? MediaQuery.of(context).size.width * 1
          : (index == 1
              ? MediaQuery.of(context).size.width * 0.95
              : (index == 2
                  ? MediaQuery.of(context).size.width * 0.9
                  : (index == 3
                      ? MediaQuery.of(context).size.width * 0.85
                      : (index == 4
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.75)))),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              color: Colors.white,
              margin: EdgeInsets.all(0),
              shape: defaultCardBorder(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// User fullname
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: user.image != null
                                ? Image.network(
                                    SERVER_IP + user.image,
                                    width: 60,
                                    height: 60,
                                  )
                                : Image.asset(
                                    'assets/images/default-user.jpg',
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name != null ? user.name : "",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                              user.email != null ? user.email : "",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    index == null || index <= 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              user.phone_number != null
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF2F2F5),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        user.phone_number != null ? user.phone_number : "",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    )
                                  : Container(),
                              user.user_cv_name != null
                                  ? Container(
                                      child: Flexible(
                                          child: Text(
                                      user.user_cv_name != null ? user.user_cv_name : "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: kColorPrimary),
                                    )))
                                  : Container(),
                            ],
                          )
                        : Container(),
                    index == null || index <= 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              user.experience_year.isEmpty
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF2F2F5),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        user.experience_year.toString(),
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 15),

                    /// User job title
                    Text(
                      user.vacancy_name != null ? user.vacancy_name : " ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    page == 'discover'
                        ? Expanded(
                            child: RichText(
                              text: TextSpan(
                                  text: user.user_cv_name != null
                                      ? user.user_cv_name
                                      : '',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black45)),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: CustomButton(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.07,
                              padding: EdgeInsets.all(5),
                              color: kColorPrimary,
                              textColor: Colors.white,
                              onPressed: () async {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder:
                                        (BuildContext context) {
                                      return ChatScreen(
                                        user_id: user.id,
                                        name: user.name,
                                        avatar: user.image,
                                      );
                                    }));
                              },
                              text: 'write_to'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
