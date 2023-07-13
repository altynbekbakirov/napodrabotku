import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/routes/routes.dart';
import 'default_card_border.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/Skill.dart';
import 'package:ishtapp/screens/edit_vacancy.dart';
import 'package:url_launcher/url_launcher.dart';

class UserView extends StatefulWidget {
  /// User object
  Users user;

  /// Screen to be checked
  final String page;

  /// Swiper position
  final SwiperPosition position;

  UserView({this.page, this.position, @required this.user});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<Widget> listings = [];
  List<Widget> requiredListings = [];

  var data = [];

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
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog1(context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(
              message,
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          actions: <Widget>[
            Container(
              child: CustomButton(
                height: 40.0,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                text: 'okay'.tr(),
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(getSubmittedVacancies());
                  StoreProvider.of<AppState>(context).dispatch(getNumberOfSubmittedVacancies());
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: kColorWhite,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    color: kColorWhite,
                    child: Container(
                      color: kColorGray,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              // color: kColorDark,
                              child: RichText(
                                softWrap: true,
                                text: TextSpan(
                                  text: widget.user.name != null ? widget.user.surname != null ? '${widget.user.name} ${widget.user.surname}\n' : '${widget.user.name.toString()}\n' : '',
                                  style: TextStyle(
                                      fontSize: widget.user.name.length > 20 ? 14 : 20,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Manrope',
                                      color: kColorDark
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.user.region != null ? widget.user.region : '',
                                        style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kColorSecondary
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: widget.user.image != null ? Image.network(
                                SERVER_IP + widget.user.image + "?token=${Guid.newGuid}",
                                headers: {"Authorization": Prefs.getString(Prefs.TOKEN)},
                                width: 60,
                                height: 60,
                              ) : Image.asset(
                                'assets/images/default-user.jpg',
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          /// Labels
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Интересуемые вакансии
                                widget.user.vacancy_type != 'null' ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: kColorGray,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text(
                                    widget.user.vacancy_type != 'null' ? widget.user.vacancy_type.toString() : '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: kColorDark,
                                    ),
                                  ),
                                ) : Container(),

                                // Вид занятости
                                widget.user.business != 'null' ?
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      color: kColorGray,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text(
                                    widget.user.business != 'null' ? widget.user.business.toString() : '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Manrope',
                                        color: kColorDark
                                    ),
                                  ),
                                )  : Container(),

                                // Статус
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      color: widget.user.status == 1 ? kColorBlue :
                                      widget.user.status == 2  ? kColorGreen : kColorGray,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text(
                                    widget.user.statusText != null ? widget.user.statusText : '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Manrope',
                                        color: kColorDark
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          /// Salary
                          Flexible(
                            child: Container(
                              child: Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      (widget.user.salary != null ? widget.user.salary : '') + ' ${widget.user.currency}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Manrope',
                                        color: kColorPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      widget.user.period != null ? widget.user.period.toLowerCase() : '',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Manrope',
                                        color: kColorPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: RichText(
                                text: TextSpan(
                                    text: widget.user.description != null ? Bidi.stripHtmlIfNeeded(widget.user.description) : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'GTEestiProDisplay',
                                        color: Colors.black45
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Flex (
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page == 'company_home' || widget.page == 'company_liked' ?
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  onPressed: () {
                                    if (Prefs.getString(Prefs.TOKEN) != null) {
                                      if(widget.page == 'company_home'){
                                        Users.saveUserCompany(userId: widget.user.id, type: 'LIKED').then((value) {
                                          StoreProvider.of<AppState>(context).state.user.liked_user_list.data.remove(widget.user);
                                          StoreProvider.of<AppState>(context).dispatch(getUsers());
                                          Navigator.of(context).pop();
                                        });
                                      } else if(widget.page == 'company_liked') {
                                        Users.deleteUserCompany(userId: widget.user.id, type: 'LIKED_THEN_DELETED').then((value) {
                                          StoreProvider.of<AppState>(context).state.user.liked_user_list.data.remove(widget.user);
                                          StoreProvider.of<AppState>(context).dispatch(getLikedUsers());
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    } else {
                                    }
                                    // Vacancy.saveVacancyUser(
                                    //     vacancy_id: widget.vacancy.id,
                                    //     type: "LIKED_THEN_DELETED")
                                    //     .then((value) {
                                    //       StoreProvider.of<AppState>(context).state.vacancy.liked_list.data.remove(widget.vacancy);
                                    //       StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                    //     });
                                    // Navigator.of(context).pop();
                                  },
                                  borderSide: BorderSide(
                                      color: kColorPrimary, width: 2.0
                                  ),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  text: widget.page == 'company_home'
                                      ? 'select_user'.tr()
                                      : widget.page == 'company_liked'
                                      ? 'delete'.tr()
                                      : 'skip'.tr(),
                                ),
                              ),
                            ) : Container(),
                            Prefs.getString(Prefs.TOKEN) != null
                                ? Flexible(
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  padding: EdgeInsets.all(0),
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (widget.page == 'company_home') {

                                    }
                                  },
                                  text: widget.page == 'company_home' || widget.page == 'company_liked'
                                      ? 'invite'.tr()
                                      : 'submit'.tr(),
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
