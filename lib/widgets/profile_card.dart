import 'package:flutter/material.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/screens/tabs/discover_tab.dart';
import 'package:ishtapp/screens/tabs/tabs_product_lab/discover_tab.dart' as ProductLab;
import 'package:swipe_stack/swipe_stack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'default_card_border.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/screens/chat_screen.dart';
import '../widgets/Dialogs/Dialogs.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_guid/flutter_guid.dart';

class ProfileCard extends StatefulWidget {
  /// User object
  final Vacancy vacancy;
  final VacanciesScreenProps props;

  /// Screen to be checked
  final String page;
  final int index;
  int offset;
  final CardController cardController;

  /// Swiper position
  final SwiperPosition position;

  ProfileCard({
    this.page,
    this.position,
    @required this.vacancy,
    this.index,
    this.offset,
    this.props,
    this.cardController,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int counter = 0;

  void removeCards({String type, int vacancy_id, props, context}) {
    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancy_id, type: type).then((value) {
        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
      });
      props.listResponse.data.remove(props.listResponse.data[0]);
    } else {
      props.listResponse.data.removeLast(props.listResponse.data[0]);
    }
    Vacancy.getVacancyByOffset(
            offset: widget.offset,
            job_type_ids: StoreProvider.of<AppState>(context).state.vacancy.job_type_ids,
            region_ids: StoreProvider.of<AppState>(context).state.vacancy.region_ids,
            schedule_ids: StoreProvider.of<AppState>(context).state.vacancy.schedule_ids,
            busyness_ids: StoreProvider.of<AppState>(context).state.vacancy.busyness_ids,
            vacancy_type_ids: StoreProvider.of<AppState>(context).state.vacancy.vacancy_type_ids,
            type: StoreProvider.of<AppState>(context).state.vacancy.type)
        .then((value) {
      if (value != null) {
        widget.offset = widget.offset + 1;
        props.listResponse.data.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isProductLabVacancy = widget.vacancy.isProductLabVacancy == null ? false : widget.vacancy.isProductLabVacancy;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
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
                padding: const EdgeInsets.all(0),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Flexible(
                      flex: 2,
                      child: Container(
                        color: kColorGray,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        // color: kColorDark,
                                        child: RichText(
                                          text: TextSpan(
                                            text: widget.vacancy.name != null
                                                ? widget.vacancy.name.toString() + '\n'
                                                : "",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Manrope',
                                                color: kColorDark
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: widget.vacancy.region != null ? widget.vacancy.region : '',
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

                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: widget.vacancy.company_logo != null
                                      ? Image.network(
                                    SERVER_IP + widget.vacancy.company_logo + "?token=${Guid.newGuid}",
                                    headers: {"Authorization": Prefs.getString(Prefs.TOKEN)},
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
                            ),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Labels
                            Flexible(
                              child: Container(
                                child: Flex(
                                  direction: Axis.vertical,
                                  mainAxisAlignment: MainAxisAlignment.start,
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

                                    isProductLabVacancy ?
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      margin: EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          color: kColorGray,
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Text(
                                        widget.vacancy.opportunityDuration != null
                                            ? widget.vacancy.opportunityDuration.toString()
                                            : "",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Manrope',
                                            color: kColorDark
                                        ),
                                      ),
                                    ) :
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
                                          (widget.vacancy.salary != null ? widget.vacancy.salary : '') + widget.vacancy.currency,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 24,
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
                                            fontSize: 16,
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

                    /// Company Name & Description
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: Text(
                                  widget.vacancy.company_name != null ? widget.vacancy.company_name : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Manrope',
                                      color: kColorSecondary),
                                ),
                              ),
                            ),

                            widget.page == 'discover' || widget.page == 'match' ?
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: widget.vacancy.description != null ? widget.vacancy.description : "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Manrope',
                                          color: kColorSecondary
                                      )
                                  ),
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page == 'submit' ? Container() :
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary,
                                      width: 2.0
                                  ),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () async {
                                    if (Prefs.getString(Prefs.TOKEN) == null) {
                                      if (Prefs.getInt(Prefs.OFFSET) > 0 && Prefs.getInt(Prefs.OFFSET) != null) {
                                        widget.offset = Prefs.getInt(Prefs.OFFSET);
                                      }
                                      widget.cardController.triggerLeft();

                                      StoreProvider.of<AppState>(context).dispatch(getNumberOfActiveVacancies());
                                    } else if (widget.page == 'discover') {
                                      widget.cardController.triggerLeft();
                                    } else if (widget.page == 'match') {
                                      Vacancy.saveVacancyUser(vacancy_id: widget.vacancy.id, type: "LIKED_THEN_DELETED")
                                          .then((value) {
                                        StoreProvider.of<AppState>(context)
                                            .state
                                            .vacancy
                                            .liked_list
                                            .data
                                            .remove(widget.vacancy);
                                        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                      });
                                    } else if (widget.page == 'company' || widget.page == 'company_inactive') {
                                      print(11);
                                      Dialogs.showOnDeleteDialog(context, 'delete_are_you_sure'.tr(), widget.vacancy);
                                    }
                                  },
                                  text: widget.page == 'discover' ? 'skip'.tr() : 'delete'.tr(),
                                ),
                              ),
                            ),

                            Prefs.getString(Prefs.TOKEN) != null ?
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  padding: EdgeInsets.all(0),
                                  color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (widget.page == 'discover') {
                                      widget.cardController.triggerRight();
                                    } else if (widget.page == 'match') {
                                      Dialogs.openLoadingDialog(context);
                                      Vacancy.saveVacancyUser(vacancy_id: widget.vacancy.id, type: "SUBMITTED")
                                          .then((value) {
                                        if (value == "OK") {
                                          Users user = new Users();
                                          Dialogs.showDialogBox(context, "successfully_submitted".tr());
                                          StoreProvider.of<AppState>(context).state.vacancy.liked_list.data.remove(widget.vacancy);
                                          StoreProvider.of<AppState>(context).dispatch(getLikedVacancies());
                                          StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                        } else {
                                          Dialogs.showDialogBox(context, "some_error_occurred_try_again".tr());
                                        }
                                      });
                                    } else if (widget.page == 'company') {
                                      Dialogs.showOnDeactivateDialog(context, 'deactivate_are_you_sure'.tr(), false, widget.vacancy);
                                    } else if (widget.page == 'company_inactive') {
                                      Dialogs.showOnDeactivateDialog(context, 'activate_are_you_sure'.tr(), true, widget.vacancy);
                                    } else if (widget.page == 'submit') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (BuildContext context) {
                                            return ChatScreen(
                                              user_id: widget.vacancy.company,
                                              name: widget.vacancy.company_name,
                                              avatar: widget.vacancy.company_logo,
                                            );
                                          })
                                      );
                                    }
                                  },

                                  text: widget.page == 'discover' ? 'like'.tr() :
                                  (
                                      widget.page == 'company' ? 'deactivate'.tr() :
                                      widget.page == 'company_inactive' ? 'activate'.tr() :
                                      widget.page == 'submit' ? 'write_to'.tr() : 'submit'.tr()
                                  ),
                                ),
                              ),
                            ) : Container(),
                          ],
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
    );
  }
}

class ProfileCardProductLab extends StatelessWidget {
  /// User object
  final Vacancy vacancy;
  final ProductLab.VacanciesScreenProps props;

  /// Screen to be checked
  final String page;
  final int index;
  int offset;
  final CardController cardController;

  /// Swiper position
  final SwiperPosition position;

  ProfileCardProductLab({
    this.page,
    this.position,
    @required this.vacancy,
    this.index,
    this.offset,
    this.props,
    this.cardController,
  });

  void removeCards({String type, int vacancy_id, props, context}) {
    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancy_id, type: type).then((value) {
        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
      });
      props.listResponse.data.remove(props.listResponse.data[0]);
    } else {
      props.listResponse.data.removeLast(props.listResponse.data[0]);
    }
    Vacancy.getVacancyByOffset(
            offset: offset,
            job_type_ids: StoreProvider.of<AppState>(context).state.vacancy.job_type_ids,
            region_ids: StoreProvider.of<AppState>(context).state.vacancy.region_ids,
            schedule_ids: StoreProvider.of<AppState>(context).state.vacancy.schedule_ids,
            busyness_ids: StoreProvider.of<AppState>(context).state.vacancy.busyness_ids,
            vacancy_type_ids: StoreProvider.of<AppState>(context).state.vacancy.vacancy_type_ids,
            type: StoreProvider.of<AppState>(context).state.vacancy.type)
        .then((value) {
      if (value != null) {
        offset = offset + 1;
        props.listResponse.data.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isProductLabVacancy = vacancy.isProductLabVacancy == null ? false : vacancy.isProductLabVacancy;
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      child: Padding(
        padding: const EdgeInsets.all(15),
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
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: vacancy.company_logo != null
                                ? Image.network(
                                    SERVER_IP + vacancy.company_logo,
                                    headers: {"Authorization": Prefs.getString(Prefs.TOKEN)},
                                    width: 70,
                                    height: 70,
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
                              text: vacancy.company_name != null ? vacancy.company_name.toString() + '\n' : "",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Manrope',
                                  color: Colors.black
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: vacancy.region != null ? vacancy.region : '',
                                    style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        vacancy.is_disability_person_vacancy == 1
                            ? Icon(
                                Icons.accessible,
                                size: 20,
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              vacancy.opportunity != null ? vacancy.opportunity.toString() : "",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                          vacancy.opportunityType != null ? vacancy.opportunityType : '',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope',
                              color: kColorPrimary),
                        )),
                      ],
                    ),
                    SizedBox(height: 5),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              vacancy.opportunityDuration != null ? vacancy.opportunityDuration.toString() : "",
                              style: TextStyle(fontFamily: 'Manrope', color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    isProductLabVacancy && vacancy.name != null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Color(0xffF2F2F5), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              vacancy.name != null ? vacancy.name : "",
                              style: TextStyle(fontFamily: 'Manrope', color: Colors.black87),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 5),
                    page == 'discover'
                        ? Expanded(
                            child: RichText(
                              text: TextSpan(
                                  text: vacancy.description != null ? vacancy.description : "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Manrope',
                                      color: Colors.black45)),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          page == 'submit'
                              ? Container()
                              : CustomButton(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  padding: EdgeInsets.all(5),
                                  color: Colors.grey[200],
                                  textColor: kColorPrimary,
                                  onPressed: () async {
                                    if (Prefs.getString(Prefs.TOKEN) == null) {
                                      if (Prefs.getInt(Prefs.OFFSET) > 0 && Prefs.getInt(Prefs.OFFSET) != null) {
                                        offset = Prefs.getInt(Prefs.OFFSET);
                                      }
                                      cardController.triggerLeft();

                                      StoreProvider.of<AppState>(context).dispatch(getNumberOfActiveVacancies());
                                    } else if (page == 'discover') {
                                      cardController.triggerLeft();
                                    } else if (page == 'match') {
                                      Vacancy.saveVacancyUser(vacancy_id: vacancy.id, type: "LIKED_THEN_DELETED")
                                          .then((value) {
                                        StoreProvider.of<AppState>(context)
                                            .state
                                            .vacancy
                                            .liked_list
                                            .data
                                            .remove(vacancy);
                                        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                      });
                                    } else if (page == 'company' || page == 'company_inactive') {
                                      print(11);
                                      Dialogs.showOnDeleteDialog(context, 'delete_are_you_sure'.tr(), vacancy);
                                    }
                                  },
                                  text: page == 'discover' ? 'skip'.tr() : 'delete'.tr(),
                                ),
                          Prefs.getString(Prefs.TOKEN) != null
                              ? Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: CustomButton(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    height: MediaQuery.of(context).size.height * 0.07,
                                    padding: EdgeInsets.all(5),
                                    color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                        ? kColorProductLab
                                        : kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (page == 'discover') {
                                        cardController.triggerRight();
                                      } else if (page == 'match') {
                                        Dialogs.openLoadingDialog(context);
                                        Vacancy.saveVacancyUser(vacancy_id: vacancy.id, type: "SUBMITTED")
                                            .then((value) {
                                          if (value == "OK") {
                                            Dialogs.showDialogBox(context, "successfully_submitted".tr());
                                            StoreProvider.of<AppState>(context)
                                                .state
                                                .vacancy
                                                .liked_list
                                                .data
                                                .remove(vacancy);
                                            StoreProvider.of<AppState>(context).dispatch(getLikedVacancies());
                                            StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
                                          } else {
                                            Dialogs.showDialogBox(context, "some_error_occurred_try_again".tr());
                                          }
                                        });
                                        // User.checkUserCv(Prefs.getInt(Prefs.USER_ID)).then((value) {
                                        //   if (value) {
                                        //
                                        //   } else {
                                        //     Dialogs.showDialogBox(context, "please_fill_user_cv_to_submit".tr());
                                        //   }
                                        // });
                                      } else if (page == 'company') {
                                        Dialogs.showOnDeactivateDialog(
                                            context, 'deactivate_are_you_sure'.tr(), false, vacancy);
                                      } else if (page == 'company_inactive') {
                                        Dialogs.showOnDeactivateDialog(
                                            context, 'activate_are_you_sure'.tr(), true, vacancy);
                                      } else if (page == 'submit') {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                          return ChatScreen(
                                            user_id: vacancy.company,
                                            name: vacancy.company_name,
                                            avatar: vacancy.company_logo,
                                          );
                                        }));
                                      }
                                    },
                                    text: page == 'discover'
                                        ? 'like'.tr()
                                        : (page == 'company'
                                            ? 'deactivate'.tr()
                                            : page == 'company_inactive'
                                                ? 'activate'.tr()
                                                : page == 'submit'
                                                    ? 'write_to'.tr()
                                                    : 'submit'.tr()),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    this.page == 'discover' ? SizedBox(height: 0) : Container(width: 0, height: 0),
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
