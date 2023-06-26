import 'package:flutter/material.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/screens/tabs/discover_tab.dart';
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

class ProfileCardUser extends StatefulWidget {
  /// User object
  final Users user;
  final UsersScreenProps props;

  /// Screen to be checked
  final String page;
  final int index;
  int offset;
  final CardController cardController;

  /// Swiper position
  final SwiperPosition position;

  ProfileCardUser({
    this.page,
    this.position,
    @required this.user,
    this.index,
    this.offset,
    this.props,
    this.cardController,
  });

  @override
  _ProfileCardUserState createState() => _ProfileCardUserState();
}

class _ProfileCardUserState extends State<ProfileCardUser> {
  int counter = 0;

  void removeCards({String type, int vacancy_id, props, context}) {
    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancy_id, type: type).then((value) {
        StoreProvider.of<AppState>(context)
            .dispatch(getNumberOfLikedVacancies());
      });
      props.listResponse.data.remove(props.listResponse.data[0]);
    } else {
      props.listResponse.data.removeLast(props.listResponse.data[0]);
    }
    Vacancy.getVacancyByOffset(
        offset: widget.offset,
        job_type_ids:
        StoreProvider.of<AppState>(context).state.vacancy.job_type_ids,
        region_ids:
        StoreProvider.of<AppState>(context).state.vacancy.region_ids,
        schedule_ids:
        StoreProvider.of<AppState>(context).state.vacancy.schedule_ids,
        busyness_ids:
        StoreProvider.of<AppState>(context).state.vacancy.busyness_ids,
        vacancy_type_ids: StoreProvider.of<AppState>(context)
            .state
            .vacancy
            .vacancy_type_ids,
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
                height: double.maxFinite,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        color: kColorGray,
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                                          maxLines: 3,
                                          text: TextSpan(
                                            text: widget.user.name != null ? widget.user.surname != null ? '${widget.user.name} ${widget.user.surname}\n' : '${widget.user.name.toString()}\n' : '',
                                            style: TextStyle(
                                              fontSize: widget.user.name.length > 20 ? 14 : 20,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Manrope',
                                              color: kColorDark,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: widget.user.region != null ? widget.user.region : '',
                                                  style: TextStyle(
                                                      fontFamily: 'Manrope',
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w500,
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
                                  child: widget.user.image != null ? Image.network(
                                    SERVER_IP + widget.user.image + "?token=${Guid.newGuid}",
                                    headers: {
                                      "Authorization":
                                      Prefs.getString(Prefs.TOKEN)
                                    },
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
                            ),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Labels
                            Flexible(
                              child: Container(
                                child: Flex(
                                  direction: Axis.vertical,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Интересуемые вакансии
                                    widget.user.vacancy_type != 'null' ? Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: kColorGray,
                                          borderRadius:
                                          BorderRadius.circular(4)
                                      ),
                                      child: Text(
                                        widget.user.vacancy_type != 'null' ? widget.user.vacancy_type.toString() : "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: kColorDark,
                                        ),
                                      ),
                                    ) : Container(),

                                    // Вид занятости
                                    widget.user.vacancy_type != 'null' ?
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      margin: EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          color: kColorGray,
                                          borderRadius:
                                          BorderRadius.circular(4)
                                      ),
                                      child: Text(
                                        widget.user.business != 'null' ? widget.user.business.toString() : "",
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
                                          color: kColorGray,
                                          borderRadius:
                                          BorderRadius.circular(4)
                                      ),
                                      child: Text(
                                        widget.user.status != null ? widget.user.status.toString() : '',
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
                            // Flexible(
                            //   child: Container(
                            //     child: Flex(
                            //       direction: Axis.vertical,
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Container(
                            //           child: Text(
                            //             (widget.vacancy.salary != null
                            //                 ? widget.vacancy.salary
                            //                 : '') +
                            //                 widget.vacancy.currency,
                            //             textAlign: TextAlign.end,
                            //             style: TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.w900,
                            //               fontFamily: 'Manrope',
                            //               color: kColorPrimary,
                            //             ),
                            //           ),
                            //         ),
                            //         Container(
                            //           child: Text(
                            //             widget.vacancy.period != null
                            //                 ? widget.vacancy.period
                            //                 .toLowerCase()
                            //                 : '',
                            //             textAlign: TextAlign.end,
                            //             style: TextStyle(
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.w700,
                            //               fontFamily: 'Manrope',
                            //               color: kColorPrimary,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    /// Company Name & Description
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.page == 'discover' || widget.page == 'match' || widget.page == 'company' ? Flexible(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: widget.user.description != null ? Bidi.stripHtmlIfNeeded(widget.user.description) : "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Manrope',
                                          color: kColorSecondary
                                      ),
                                  ),
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page == 'submit' ? Container() : Flexible(
                              flex: 1,
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary, width: 2.0),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () async {
                                    if (Prefs.getString(Prefs.TOKEN) ==
                                        null) {
                                      if (Prefs.getInt(Prefs.OFFSET) >
                                          0 &&
                                          Prefs.getInt(Prefs.OFFSET) !=
                                              null) {
                                        widget.offset =
                                            Prefs.getInt(Prefs.OFFSET);
                                      }
                                      widget.cardController.triggerLeft();

                                      StoreProvider.of<AppState>(context)
                                          .dispatch(
                                          getNumberOfActiveVacancies());
                                    } else if (widget.page ==
                                        'discover') {
                                      widget.cardController.triggerLeft();
                                    } else if (widget.page == 'match') {
                                      // Vacancy.saveVacancyUser(
                                      //     vacancy_id:
                                      //     widget.vacancy.id,
                                      //     type: "LIKED_THEN_DELETED")
                                      //     .then((value) {
                                      //   StoreProvider.of<AppState>(
                                      //       context)
                                      //       .state
                                      //       .vacancy
                                      //       .liked_list
                                      //       .data
                                      //       .remove(widget.vacancy);
                                      //   StoreProvider.of<AppState>(
                                      //       context)
                                      //       .dispatch(
                                      //       getNumberOfLikedVacancies());
                                      // });
                                    } else if (widget.page == 'company' ||
                                        widget.page ==
                                            'company_inactive') {
                                      // Dialogs.showOnDeleteDialog(
                                      //     context,
                                      //     'delete_are_you_sure'.tr(),
                                      //     widget.vacancy);
                                    }
                                  },
                                  text: widget.page == 'discover'
                                      ? 'skip'.tr()
                                      : 'delete'.tr(),
                                ),
                              ),
                            ),
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
                                    if (widget.page == 'discover') {
                                      widget.cardController
                                          .triggerRight();
                                    } else if (widget.page == 'match') {
                                      Dialogs.openLoadingDialog(context);
                                      // Vacancy.saveVacancyUser(
                                      //     vacancy_id:
                                      //     widget.vacancy.id,
                                      //     type: "SUBMITTED")
                                      //     .then((value) {
                                      //   if (value == "OK") {
                                      //     Users user = new Users();
                                      //     Dialogs.showDialogBox(
                                      //         context,
                                      //         "successfully_submitted"
                                      //             .tr());
                                      //     StoreProvider.of<AppState>(
                                      //         context)
                                      //         .state
                                      //         .vacancy
                                      //         .liked_list
                                      //         .data
                                      //         .remove(widget.vacancy);
                                      //     StoreProvider.of<AppState>(
                                      //         context)
                                      //         .dispatch(
                                      //         getLikedVacancies());
                                      //     StoreProvider.of<AppState>(
                                      //         context)
                                      //         .dispatch(
                                      //         getNumberOfLikedVacancies());
                                      //   } else {
                                      //     Dialogs.showDialogBox(
                                      //         context,
                                      //         "some_error_occurred_try_again"
                                      //             .tr());
                                      //   }
                                      // });
                                    } else if (widget.page == 'company') {
                                      // Dialogs.showOnDeactivateDialog(
                                      //     context,
                                      //     'deactivate_are_you_sure'.tr(),
                                      //     false,
                                      //     widget.vacancy);
                                    } else if (widget.page == 'company_inactive') {
                                      // Dialogs.showOnDeactivateDialog(
                                      //     context,
                                      //     'activate_are_you_sure'.tr(),
                                      //     true,
                                      //     widget.vacancy);
                                    } else if (widget.page == 'submit') {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder:
                                      //         (BuildContext context) {
                                      //       return ChatScreen(
                                      //         user_id: widget.vacancy.company,
                                      //         name:
                                      //         widget.vacancy.company_name,
                                      //         vacancy_id: widget.vacancy.id,
                                      //         vacancy: widget.vacancy.name,
                                      //         avatar:
                                      //         widget.vacancy.company_logo,
                                      //       );
                                      //     }));
                                    }
                                  },
                                  text: widget.page == 'discover'
                                      ? 'like'.tr()
                                      : (widget.page == 'company'
                                      ? 'deactivate'.tr()
                                      : widget.page ==
                                      'company_inactive'
                                      ? 'activate'.tr()
                                      : widget.page == 'submit'
                                      ? 'write_to'.tr()
                                      : 'submit'.tr()),
                                ),
                              ),
                            )
                                : Container(),
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
