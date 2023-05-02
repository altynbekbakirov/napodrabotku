import 'package:flutter/material.dart';
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
  final Vacancy vacancy;

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
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('okay'.tr()),
              onPressed: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(getSubmittedVacancies());
                StoreProvider.of<AppState>(context)
                    .dispatch(getNumberOfSubmittedVacancies());
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
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
    bool isProductLabVacancy = widget.vacancy.isProductLabVacancy == null ? false : widget.vacancy.isProductLabVacancy;
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            /// User Card
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: widget.vacancy.company_logo != null
                                        ? Image.network(
                                            SERVER_IP + widget.vacancy.company_logo.toString(),
                                            headers: {"Authorization": Prefs.getString(Prefs.TOKEN)},
                                            width: 50,
                                            height: 50,
                                          )
                                        : Image.asset(
                                            'assets/images/default-user.jpg',
                                            fit: BoxFit.cover,
                                            width: 70,
                                            height: 70,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: widget.vacancy.company_name != null
                                          ? widget.vacancy.company_name.toString() + '\n'
                                          : "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'GTEestiProDisplay',
                                          color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: widget.vacancy.region != null ? widget.vacancy.region : "",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'GTEestiProDisplay',
                                                color: kColorDark)),
                                      ],
                                    ),
                                  ),
                                ),
                                widget.vacancy.is_disability_person_vacancy == 1
                                    ? Icon(
                                        Icons.accessible,
                                        size: 20,
                                      )
                                    : Container(),
                              ],
                            ),

                            SizedBox(height: 20),
                            isProductLabVacancy
                                ? Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "feature_name".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.name != null ? widget.vacancy.name : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            isProductLabVacancy
                                ? Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "choice_opportunity_options".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.opportunity != null
                                                ? widget.vacancy.opportunity.toString()
                                                : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          widget.vacancy.type != null ? widget.vacancy.type.toString() : "",
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      widget.vacancy.salary != null
                                          ? Flexible(
                                              child: Text(
                                              widget.vacancy.salary != null ? widget.vacancy.salary : '',
                                              style: TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.bold, color: kColorPrimary),
                                            ))
                                          : Container(),
                                    ],
                                  ),
                            SizedBox(height: 5),

                            isProductLabVacancy
                                ? Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "opportunity_type".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.opportunityType != null
                                                ? widget.vacancy.opportunityType.toString()
                                                : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            isProductLabVacancy
                                ? Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "internship_language".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.internshipLanguage != null
                                                ? widget.vacancy.internshipLanguage.toString()
                                                : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(height: 10),
                            isProductLabVacancy
                                ? Flex(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "opportunity_duration".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.opportunityDuration != null
                                                ? widget.vacancy.opportunityDuration.toString()
                                                : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                          widget.vacancy.schedule != null ? widget.vacancy.schedule.toString() : "",
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 10),

                            Prefs.getString(Prefs.ROUTE) == 'USER' ? Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.vacancy.name != null ? widget.vacancy.name : "",
                                    style: TextStyle(
                                        fontFamily: 'GTEestiProDisplay',
                                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                              ],
                            ) : Container(),

                            /// Uer job title
                            widget.page == 'discover'
                                ? Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                          text: widget.vacancy.description != null ? widget.vacancy.description : "",
                                          style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black45)),
                                    ),
                                  )
                                : SizedBox(),

                            isProductLabVacancy
                                ? Flex(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Готовность выдать рекомендательное письмо:",
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.typeOfRecommendedLetter != null
                                                ? widget.vacancy.typeOfRecommendedLetter.toString()
                                                : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            Prefs.getString(Prefs.ROUTE) == 'USER' ? SizedBox() : SizedBox(height: 10),
                            isProductLabVacancy
                                ? Flex(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "opportunity_age".tr(),
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            "${widget.vacancy.ageFrom}-${widget.vacancy.ageTo}",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),

                            Prefs.getString(Prefs.ROUTE) == 'USER' ? SizedBox() : SizedBox(height: 10),
                            isProductLabVacancy
                                ? Flex(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Дедлайн заявки",
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                                          child: Text(
                                            widget.vacancy.deadline != null ? widget.vacancy.deadline : "",
                                            style: TextStyle(color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),

                            Prefs.getString(Prefs.ROUTE) == 'USER' ? SizedBox() : SizedBox(height: 10),
                            widget.page != 'discover' && widget.vacancy.isProductLabVacancy
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Дополнительная информация:",
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  widget.vacancy.description != null ? widget.vacancy.description : "",
                                              style: TextStyle(
                                                  fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black45)),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),

                            /// Ссылка на сайт
                            widget.vacancy.vacancyLink != null ? SizedBox(height: 20) : Container(),
                            widget.vacancy.vacancyLink != null
                                ? CustomButton(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    padding: EdgeInsets.all(5),
                                    color: kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () => _launchURL(widget.vacancy.vacancyLink),
                                    text: 'link'.tr(),
                                  )
                                : Container(),
                            SizedBox(height: 20),
                            // Flex(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   direction: Axis.horizontal,
                            //   children: [
                            //     Flexible(
                            //       child: Text(
                            //         "Ссылка на сайт",
                            //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                            //       ),
                            //     ),
                            //     Flexible(
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            //         decoration:
                            //             BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                            //         child: Text(
                            //           widget.vacancy.vacancyLink ?? "",
                            //           style: TextStyle(color: Colors.black87),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            isProductLabVacancy
                                ? Align(
                                    widthFactor: 10,
                                    heightFactor: 1.5,
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Навыки",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kColorPrimary),
                                    ),
                                  )
                                : Container(),

                            isProductLabVacancy
                                ? Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Требуется:'.tr(),
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      requiredListings == null || requiredListings.isEmpty
                                          ? Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: BoxConstraints(
                                                minHeight: 30,
                                              ),
                                              child: Text(
                                                "empty".tr(),
                                                style: TextStyle(
                                                    fontSize: 12, fontWeight: FontWeight.bold, color: kColorPrimary),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Column(children: requiredListings),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Могут развить:'.tr(),
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      listings == null || listings.isEmpty
                                          ? Container(
                                              constraints: BoxConstraints(
                                                minHeight: 30,
                                              ),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "empty".tr(),
                                                  style: TextStyle(
                                                      fontSize: 12, fontWeight: FontWeight.bold, color: kColorPrimary),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          : Column(children: listings),
                                    ],
                                  )
                                : Container(),

                            isProductLabVacancy
                                ? Container()
                                : Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: RichText(
                                        text: TextSpan(
                                            text: widget.vacancy.description != null ? widget.vacancy.description : "",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'GTEestiProDisplay',
                                                color: Colors.black45)),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    widget.page != 'user_match'
                        ? SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.page == 'discover'
                                    ? Container()
                                    : widget.page == 'company_view'
                                        ? Center(
                                            child: CustomButton(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              padding: EdgeInsets.all(5),
                                              color: kColorPrimary,
                                              textColor: Colors.white,
                                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) => EditVacancy(
                                                        vacancy: widget.vacancy,
                                                        vacancySkill: widget.vacancySkill,
                                                      ))),
                                              text: 'edit'.tr(),
                                            ),
                                          )
                                        : widget.page == 'submitted'
                                            ? Container(
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.symmetric(vertical: 10),
                                                decoration: BoxDecoration(
                                                    color: kColorDarkBlue, borderRadius: BorderRadius.circular(12)),
                                                child: Center(
                                                  child: Text(
                                                      recruited == 0
                                                          ? "На рассмотрении"
                                                          : recruited == 1
                                                              ? "Одобрено"
                                                              : "Попробуйте в следующий раз",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ),
                                              )
                                            : widget.page == 'inactive'
                                                ? Container()
                                                : Center(
                                                    child: CustomButton(
                                                      width: MediaQuery.of(context).size.width * 0.35,
                                                      padding: EdgeInsets.all(5),
                                                      color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                          ? kColorProductLab
                                                          : kColorPrimary,
                                                      textColor: Colors.white,
                                                      onPressed: () {
                                                        Prefs.getString(Prefs.TOKEN) == null
                                                            ? _showDialog(context, 'sign_in_to_submit'.tr())
                                                            : Vacancy.saveVacancyUser(
                                                                    vacancy_id: widget.vacancy.id, type: "SUBMITTED")
                                                                .then((value) {
                                                                if (value == "OK") {
                                                                  _showDialog1(context, "successfully_submitted".tr());
                                                                  StoreProvider.of<AppState>(context)
                                                                      .state
                                                                      .vacancy
                                                                      .list
                                                                      .data
                                                                      .remove(widget.vacancy);
                                                                  StoreProvider.of<AppState>(context)
                                                                      .dispatch(getSubmittedVacancies());
                                                                  StoreProvider.of<AppState>(context)
                                                                      .dispatch(getNumberOfSubmittedVacancies());
                                                                } else {
                                                                  _showDialog(
                                                                      context, "some_errors_occured_try_again".tr());
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
                          )
                        : Container(),
                    this.widget.page == 'discover' ? SizedBox(height: 0) : Container(width: 0, height: 0),
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
