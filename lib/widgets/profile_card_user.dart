import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/routes/routes.dart';
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
  final CardController cardController;

  /// Swiper position
  final SwiperPosition position;

  ProfileCardUser({
    this.page,
    this.position,
    @required this.user,
    this.index,
    this.props,
    this.cardController,
  });

  @override
  _ProfileCardUserState createState() => _ProfileCardUserState();
}

class _ProfileCardUserState extends State<ProfileCardUser> {
  int counter = 0;
  bool loading = false;

  int vacancyId;
  List<dynamic> vacancyList = [];

  final _vacancyAddFormKey = GlobalKey<FormState>();

  Future<void> openInviteDialog(context) async {

    print(vacancyList);

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return
            Dialog(
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
                                    items: vacancyList.map<DropdownMenuItem<int>>((dynamic value) {
                                      var jj = new JobType(id: value.id, name: value.name);
                                      if(value.status == 'active'){
                                        return DropdownMenuItem<int>(
                                          value: jj.id,
                                          child: Text(jj.name),
                                        );
                                      }
                                      return null;
                                    }).toList(),
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
        });
  }

  @override
  void initState() {
    super.initState();
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
              elevation: 0,
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

                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Labels
                            Flexible(
                              flex: 4,
                              child: Container(
                                child: Flex(
                                  direction: Axis.vertical,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                            ),

                            /// Salary
                            Flexible(
                              flex: 2,
                              child: Container(
                                child: Flex(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        (widget.user.salary != null ? widget.user.salary : '') +
                                            ' ${widget.user.currency}',
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
                                        widget.user.period != null
                                            ? widget.user.period
                                            .toLowerCase()
                                            : '',
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

                    /// Company Name & Description
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.page == 'company_home' || widget.page == 'company_responses' ? Flexible(
                              child: Container(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
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
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page == 'submit' ? Container() : Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary, width: 2.0
                                  ),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () async {
                                    if (Prefs.getString(Prefs.TOKEN) == null) {
                                    } else if (widget.page == 'company_home') {
                                      removeCard(
                                          props: widget.props,
                                          type: "LIKED",
                                          userId: widget.user.id,
                                          user: widget.user,
                                          context: context
                                      );
                                    }
                                  },
                                  text: widget.page == 'company_home'
                                      ? 'select_user'.tr()
                                      : 'skip'.tr(),
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
                                    // if (widget.page == 'company_home') {
                                    //
                                    // }
                                    StoreProvider.of<AppState>(context).dispatch(getCompanyActiveVacancies());
                                    setState(() {
                                      vacancyList = StoreProvider.of<AppState>(context).state.vacancy.active_list.data;
                                    });
                                    openInviteDialog(context);
                                  },
                                  text: widget.page == 'company_home'
                                      ? 'invite'.tr()
                                      : 'submit'.tr(),
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

  void removeCard({String type, int userId, props, context, Users user}) {

    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        // props.addOneToMatches();
      }
      Users.saveUserCompany(userId: userId, type: type).then((value) {
        props.listResponse.data.remove(user);
        StoreProvider.of<AppState>(context).dispatch(getUsers());
        // Navigator.of(context).pop();
      });
    } else {
    }
  }
}
