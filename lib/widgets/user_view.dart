import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/widgets/Dialogs/Dialogs.dart';
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
  final List<Vacancy> vacancyList;

  UserView({this.page, this.position, @required this.user, this.vacancyList,});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<Widget> listings = [];
  List<Widget> requiredListings = [];

  var data = [];

  int vacancyId;
  List<dynamic> _vacancyList = [];

  final _vacancyAddFormKey = GlobalKey<FormState>();

  Future<void> openInviteDialog(context) async {

    _vacancyList = widget.vacancyList.map<DropdownMenuItem<int>>((dynamic value) {
      var jj = new Vacancy(id: value.id, name: value.name);
      return DropdownMenuItem<int>(
        value: jj.id,
        child: Text(jj.name.toString()),
      );
    }).toList();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'choose_vacancy'.tr(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          )
                      ),
                    ),

                    /// Form
                    Form(
                      key: _vacancyAddFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            child: Column(

                              children: [
                                DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  hint: Text("select".tr()),
                                  value: vacancyId,
                                  onChanged: (int newValue) {
                                    setState(() {
                                      vacancyId = newValue;
                                    });
                                  },
                                  focusNode: FocusNode(canRequestFocus: false),
                                  validator: (value) => value == null ? "please_fill_this_field".tr() : null,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                    errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: kColorWhite,
                                  ),
                                  items: _vacancyList,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: double.maxFinite,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary,
                                      width: 2.0
                                  ),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () {
                                    setState(() {
                                      vacancyId = null;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  text: 'cancel'.tr(),
                                ),
                                CustomButton(
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (_vacancyAddFormKey.currentState.validate()) {

                                      Vacancy.saveVacancyUserInvite(vacancy_id: vacancyId, type: "INVITED", user_id: widget.user.id).then((value) {
                                        if (value == "OK") {
                                          // Dialogs.showDialogBox(context,"successfully_submitted".tr());
                                          StoreProvider.of<AppState>(context).state.user.list.data.remove(widget.user);
                                          StoreProvider.of<AppState>(context).dispatch(getUsers());
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        } else {
                                          Dialogs.showDialogBox(context,"some_error_occurred_try_again".tr());
                                        }
                                      });

                                      setState(() {
                                        vacancyId = null;
                                      });
                                    } else {
                                      print('invalid');
                                    }
                                  },
                                  text: 'send'.tr(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
                      color: widget.user.response_type == 'SUBMITTED' ? kColorYellow : kColorGray,
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
                                        text: widget.user.district != null ? widget.user.age != null ? widget.user.district + ', ' + widget.user.age + ' ' + 'years'.tr() : widget.user.district : '',
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
                              child: widget.user.image != null ?
                              CachedNetworkImage(
                                // imageUrl: SERVER_IP + widget.user.image + "?token=${Guid.newGuid}",
                                imageUrl: SERVER_IP + widget.user.image,
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                httpHeaders: {
                                  "Authorization": Prefs.getString(Prefs.TOKEN)
                                },
                                placeholder: (context, url) => Container(
                                  padding: EdgeInsets.all(10),
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Image.asset("assets/images/default-user.jpg"),
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

                  widget.page == 'submitted' ? Container(
                    child: Container(
                      color: widget.user.response_type == 'SUBMITTED' ? kColorGray : kColorYellow,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.response_type == 'SUBMITTED' ? widget.user.response_read ?
                            'просмотрен отклик на вакансию \n"${widget.user.vacancy_name}"' :
                            'новый отклик на вакансию \n"${widget.user.vacancy_name}"' :
                            'приглашен на вакансию \n"${widget.user.vacancy_name}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1,
                              fontWeight: FontWeight.bold,
                              color: kColorDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Container(),

                  Container(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          /// Labels
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  // Статус

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.only(right: 5, top: 5),
                                    decoration: BoxDecoration(
                                        color: widget.user.status == 0 ? kColorBlue :
                                        widget.user.status == 1  ? kColorGreen : kColorGray,
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


                                  // Интересуемые вакансии

                                  for ( var vacancy_type in widget.user.vacancy_types) Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.only(right: 5, top: 5),
                                    decoration: BoxDecoration(
                                        color: kColorGray,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(
                                      vacancy_type.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: kColorDark,
                                      ),
                                    ),
                                  ),

                                  // Графики работы

                                  for ( var schedule in widget.user.schedules) Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.only(right: 5, top: 5),
                                    decoration: BoxDecoration(
                                        color: kColorGray,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(
                                      schedule.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: kColorDark,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
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
                            widget.page == 'company_home' || widget.page == 'company_liked' || widget.page == 'submitted' ?
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  onPressed: () {
                                    if (Prefs.getString(Prefs.TOKEN) != null) {
                                      if(widget.page == 'company_home' || widget.page == 'submitted'){
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
                                  text: widget.page == 'company_home' ? 'select_user'.tr() :
                                  widget.page == 'company_liked' || widget.page == 'submitted' ?
                                  'delete'.tr() :
                                  'skip'.tr(),
                                ),
                              ),
                            ) : Container(),
                            Prefs.getString(Prefs.TOKEN) != null
                                ? widget.user.response_type == 'SUBMITTED' ?  Container() : Flexible(
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  padding: EdgeInsets.all(0),
                                  color: widget.user.response_type == 'INVITED' ? kColorGray : kColorPrimary,
                                  textColor: widget.user.response_type == 'INVITED' ? kColorDarkBlue : Colors.white,
                                  onPressed: () async {
                                    if(widget.page == 'company_home'){
                                      await openInviteDialog(context);
                                    }
                                  },
                                  text: widget.page == 'company_home' || widget.page == 'company_liked' ? 'invite'.tr() :
                                  widget.page == 'submitted' && widget.user.response_type == 'INVITED' ?
                                  'Отправлено'.tr() :
                                  'submit'.tr(),
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  widget.page == 'submitted' ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Flex (
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  padding: EdgeInsets.all(0),
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    _makePhoneCall("tel://"+widget.user.phone_number);
                                  },
                                  text: widget.user.phone_number,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
