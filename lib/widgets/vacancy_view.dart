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

class VacancyView extends StatefulWidget {
  /// User object
  Vacancy vacancy;

  /// Screen to be checked
  final String page;

  /// Swiper position
  final SwiperPosition position;

  final List<VacancySkill> vacancySkill;

  VacancyView({this.page, this.position, @required this.vacancy, this.vacancySkill});

  @override
  _VacancyViewState createState() => _VacancyViewState();
}

class _VacancyViewState extends State<VacancyView> {
  List<Widget> listings = [];
  List<Widget> requiredListings = [];

  var data = [];
  int recruited = 0;

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
            // CustomButton(
            //     text: "sign_in".tr(),
            //     textColor: kColorPrimary,
            //     color: Colors.white,
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //       Navigator.of(context).popUntil((route) => route.isFirst);
            //       Navigator.pushNamed(context, Routes.start);
            //     }
            // )
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

  void getRecruit() async {
    Users user = new Users();
    user.getRecruit(widget.vacancy.id).then((value) => setState(() {
          recruited = value;
        }));
  }

  initData() {
    if (widget.vacancySkill != null && widget.vacancySkill.length > 0) {
      data = widget.vacancySkill;
    } else {
      VacancySkill.getVacancySkills(widget.vacancy.id).then((value) {
        List<VacancySkill> vacancySkills = [];

        for (var i in value) {
          vacancySkills.add(new VacancySkill(
            id: i.id,
            name: i.name,
            vacancyId: i.vacancyId,
            isRequired: i.isRequired,
          ));
        }
        data = vacancySkills;
      });
    }
  }

  void vacancySkills() {
    print(data);
    if (data == null || data.length == 0) {
      listings.add(Container());
    } else {
      for (var item in data) {
        if (item.isRequired) {
          requiredListings.add(Container(
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
              child: Text(item.name, style: TextStyle(color: Colors.black87)),
            ),
          ));
        } else {
          listings.add(
            Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                child: Text(item.name, style: TextStyle(color: Colors.black87)),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    if (widget.page == 'submitted') {
      getRecruit();
    }
    initData();
    vacancySkills();
    super.initState();
  }

  _launchURL(url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url \n Error: $e';
    }
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
                                  text: widget.vacancy.name != null ? widget.vacancy.name.toString() + '\n' : "",
                                  style: TextStyle(
                                      fontSize: widget.vacancy.name.length > 20 ? 16 : 20,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Manrope',
                                      color: kColorDark
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.vacancy.district != null ? widget.vacancy.district : '',
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
                              child: widget.vacancy.company_logo != null ? Image.network(
                                SERVER_IP + widget.vacancy.company_logo + "?token=${Guid.newGuid}",
                                key: ValueKey(SERVER_IP + widget.vacancy.company_logo + "?token=${Guid.newGuid}"),
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
                                widget.vacancy.type != null ?
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: kColorGray,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text(
                                    widget.vacancy.type != null ? widget.vacancy.type.toString() : "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: kColorDark,
                                    ),
                                  ),
                                ) : Container(),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      color: kColorGray,
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Text(
                                    widget.vacancy.schedule != null ? widget.vacancy.schedule.toString() : "",
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
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    (widget.vacancy.salary != null ? widget.vacancy.salary : '') + widget.vacancy.currency,
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
                                    widget.vacancy.period != null ? widget.vacancy.period.toLowerCase() : '',
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
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              widget.vacancy.company_name != null ? widget.vacancy.company_name : "",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Manrope',
                                  color: kColorSecondary),
                            ),
                          ),

                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: RichText(
                                text: TextSpan(
                                    text: widget.vacancy.description != null ? Bidi.stripHtmlIfNeeded(widget.vacancy.description) : "",
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
                    margin: EdgeInsets.all(20),
                    child: Container(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Flex (
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page == 'user_match' ?
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: CustomButton(
                                  onPressed: () {
                                    Vacancy.saveVacancyUser(
                                        vacancy_id: widget.vacancy.id,
                                        type: "LIKED_THEN_DELETED")
                                        .then((value) {
                                          StoreProvider.of<AppState>(context).state.vacancy.liked_list.data.remove(widget.vacancy);
                                          StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                        });
                                    Navigator.of(context).pop();
                                  },
                                  borderSide: BorderSide(
                                      color: kColorPrimary, width: 2.0
                                  ),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  text: 'delete'.tr(),
                                ),
                              ),
                            ) : Container(),
                            widget.page == 'discover' ? Container() :
                            widget.page == 'company_view' ?
                            Center(
                              child: CustomButton(
                                color: kColorPrimary,
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => EditVacancy(
                                        vacancy: widget.vacancy,
                                        vacancySkill: widget.vacancySkill,
                                      )
                                  )
                                  );
                                },
                                text: 'edit'.tr(),
                              ),
                            ) :
                            widget.page == 'submitted' ?
                            CustomButton(
                              onPressed: () {},
                              color: kColorDarkBlue,
                              text: recruited == 0 ? "На рассмотрении" : recruited == 1 ? "Одобрено" : "Попробуйте в следующий раз",
                            ) :
                            widget.page == 'inactive' ? Container() :
                            Center(
                              child: CustomButton(
                                color: kColorPrimary,
                                textColor: Colors.white,
                                onPressed: () {
                                  Prefs.getString(Prefs.TOKEN) == null ?
                                  _showDialog(context, 'sign_in_to_submit'.tr()) :
                                  Vacancy.saveVacancyUser(vacancy_id: widget.vacancy.id, type: "SUBMITTED").then((value) {
                                    if (value == "OK") {
                                      _showDialog1(context, "successfully_submitted".tr());
                                      StoreProvider.of<AppState>(context).state.vacancy.list.data.remove(widget.vacancy);
                                      StoreProvider.of<AppState>(context).dispatch(getSubmittedVacancies());
                                      StoreProvider.of<AppState>(context).dispatch(getNumberOfSubmittedVacancies());
                                    } else {
                                      _showDialog(context, "some_errors_occured_try_again".tr());
                                    }
                                  });
                                  // User.checkUserCv(Prefs.getInt(Prefs.USER_ID))
                                  //         .then((value) {

                                  // if (value) {
                                  //
                                  // } else {
                                  //   _showDialog(context, "please_fill_user_cv_to_submit".tr());
                                  // }
                                  // });
                                },
                                text: 'submit'.tr(),
                              ),
                            ),
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
