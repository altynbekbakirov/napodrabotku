import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/screens/company_vacancies_screen.dart';
import 'package:ishtapp/screens/profile_likes_screen.dart';
import 'package:ishtapp/screens/profile_visits_screen.dart';
import 'package:ishtapp/screens/edit_profile_screen.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:redux/redux.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_guid/flutter_guid.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Users user;
  int counter = 0;

  List<dynamic> statuses = [
    {
      'id': 0,
      'name': 'Активно ищу работу',
    },
    {
      'id': 1,
      'name': 'Могу выйти завтра',
    },
    {
      'id': 2,
      'name': 'Рассматриваю предложения',
    },
  ];
  int selectedStatus;
  List<dynamic> vacancyTypeList = [];
  List<dynamic> scheduleList = [];
  List _vacancyTypes = [];
  List _schedules = [];

  getLists() async {
    await Vacancy.getLists('vacancy_type', null).then((value) {
      setState(() {
        vacancyTypeList = value;
      });
    });
    await Vacancy.getLists('schedule', null).then((value) {
      setState(() {
        scheduleList = value;
      });
    });
  }

  // getSchedules(id) async {
  //   await Users.getSchedules(id).then((value) {
  //     setState(() {
  //       _schedules = value;
  //     });
  //   });
  // }
  //
  // getVacancyTypes(id) async {
  //   await Users.getVacancyTypes(id).then((value) {
  //     setState(() {
  //       _vacancyTypes = value;
  //     });
  //   });
  // }

  void handleInitialBuild(ProfileScreenProps props) {
    if (Prefs.getString(Prefs.TOKEN) != "null" && Prefs.getString(Prefs.TOKEN) != null) {
      if(Prefs.getString(Prefs.USER_TYPE) == "USER") {
        props.getUser();
        props.getUserCv();
        props.getSubmittedNumber();
      } else {
        props.getUser();
        props.getUserCv();
        props.getCompanyVacancies();
        props.getCompanyActiveVacancies();
        props.getCompanyInactiveVacancies();
      }
    }
  }

  final _textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: kColorDark
  );

  final _textStyle2 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: kColorPrimary
  );

  showOnDeleteDialog(context, userId) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        heightFactor: 1 / 2,
        child: AlertDialog(
          backgroundColor: kColorWhite,
          title: Text(''),
          content: Text(
            "account_will_be_deleted".tr(),
            style: TextStyle(color: kColorPrimary),
            textAlign: TextAlign.center,
          ),

          actionsPadding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
          actions: <Widget>[
            CustomButton(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.all(10),
              color: kColorPrimary,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              text: 'cancel'.tr(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.all(10),
              child: FlatButton(
                child: Text(
                  'delete'.tr(),
                  style: TextStyle(color: kColorPrimary),
                ),
                onPressed: () {
                  Users.deleteUser().then((value) {
                    Prefs.setString(Prefs.EMAIL, null);
                    Prefs.setString(Prefs.PROFILEIMAGE, null);
                    Prefs.setString(Prefs.PASSWORD, null);
                    Prefs.setString(Prefs.TOKEN, null);
                    Prefs.setString(Prefs.USER_TYPE, null);
                    Prefs.setString(Prefs.ROUTE, null);
                    Prefs.setInt(Prefs.USER_ID, null);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, Routes.select_mode);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    selectedStatus = Prefs.getInt(Prefs.USER_STATUS);
    getLists();
    // getSchedules(Prefs.getInt(Prefs.USER_ID));
    // getVacancyTypes(Prefs.getInt(Prefs.USER_ID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, ProfileScreenProps>(
      converter: (store) => mapStateToProps(store),
      onInitialBuild: (props) => this.handleInitialBuild(props),
      builder: (context, props) {
        bool loading = props.user.loading;

        Widget body;

        if (loading) {
          body = Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {

          if(Prefs.getString(Prefs.USER_TYPE) == "USER" && StoreProvider.of<AppState>(context).state.user.user.data != null) {
            if(StoreProvider.of<AppState>(context).state.user.user.data.vacancy_types != null){
              _vacancyTypes = StoreProvider.of<AppState>(context).state.user.user.data.vacancy_types;
            }
            if(StoreProvider.of<AppState>(context).state.user.user.data.schedules != null){
              _schedules = StoreProvider.of<AppState>(context).state.user.user.data.schedules;
            }
          }

          body = SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Basic profile info
                Container(
                  child: Column(
                    children: [

                      /// Profile image
                      Container(
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: kColorPrimary,
                          radius: 60,
                          backgroundImage: Prefs.getString(Prefs.PROFILEIMAGE) != null
                              ? NetworkImage(
                              SERVER_IP + Prefs.getString(Prefs.PROFILEIMAGE) + "?token=${Guid.newGuid}",
                              headers: {"Authorization": Prefs.getString(Prefs.TOKEN)})
                              : null,
                        ),
                      ),

                      Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.PHONE_NUMBER) : 'guest_user'.tr(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ) :
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.EMAIL) : 'guest_user'.tr(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),

                      Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: DropdownButtonFormField<int>(
                          isExpanded: true,
                          hint: Text("select".tr()),
                          value: selectedStatus,
                          onChanged: (int newValue) async {
                            setState(() {
                              selectedStatus = newValue;
                              Prefs.setInt(Prefs.USER_STATUS, newValue);
                            });

                            await Users.changeStatus(status: newValue);
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
                          items: statuses.map<DropdownMenuItem<int>>((dynamic value) {
                            return DropdownMenuItem<int>(
                              value: value['id'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                        ),
                      ) : Container(),

                      /// Buttons
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Prefs.getString(Prefs.TOKEN) != null ? Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                child: CustomButton(
                                  padding: EdgeInsets.all(0),
                                  color: kColorPrimary,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(Routes.user_details);
                                  },
                                  text: 'about_me'.tr(),
                                ),
                              ),
                            ) : Container() : Container(),
                            Prefs.getString(Prefs.TOKEN) != null ?
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorPrimary,
                                      width: 2.0
                                  ),
                                  padding: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  textColor: kColorPrimary,
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditProfileScreen()),
                                    );
                                    setState(() {});
                                  },
                                  text: 'settings'.tr(),
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),

                      Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                ('Меня интересуют').tr().toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kColorDarkBlue
                                ),
                              ),
                            ),
                            vacancyTypeList.length > 0 ? MultiSelectFormField(
                              fillColor: kColorWhite,
                              autovalidate: true,
                              title: Text(
                                'vacancy_types'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                if(value.length > 3) {
                                  return 'max_allowed_3_options'.tr();
                                }
                                return null;
                              },
                              change: (value) {
                                print(value);
                              },
                              dataSource: vacancyTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _vacancyTypes,
                              onSaved: (value) async {
                                if(value == null) return null;
                                if(value.length > 3) return null;
                                setState(() {
                                  _vacancyTypes = value;
                                });
                                await Users.changeVacancyTypes(vacancyTypes: _vacancyTypes);
                              },
                            ) : Container(),
                            SizedBox(height: 10),
                            scheduleList.length > 0 ? MultiSelectFormField(
                              autovalidate: true,
                              fillColor: kColorWhite,
                              title: Text(
                                'schedules'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                if(value.length > 3) {
                                  return 'max_allowed_3_options'.tr();
                                }
                                return null;
                              },
                              dataSource: scheduleList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _schedules,
                              onSaved: (value) async {
                                if(value == null) return null;
                                if(value.length > 3) return null;
                                setState(() {
                                  _schedules = value;
                                });
                                await Users.changeSchedule(schedules: _schedules);
                              },
                            ) : Container(),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                ),

                /// Profile Statistics Card
                Prefs.getString(Prefs.TOKEN) != null ?
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.none,
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Boxicons.bx_file_blank,
                                            size: 25,
                                            color: kColorPrimary,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                              color: kColorGray,
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                              'all_vacancies'.tr(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: kColorDark
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Text(
                                    props.list.data != null && props.list.data.length > 0 ? props.list.data.length.toString() : '0',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          /// Go to profile likes screen
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyVacanciesScreen()));
                        },
                      ) : Container(),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    clipBehavior: Clip.none,
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Boxicons.bx_like,
                                            size: 25,
                                            color: kColorPrimary,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                              color: kColorGray,
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                              Prefs.getString(Prefs.USER_TYPE) == 'USER' ? "matches".tr() : 'active_vacancies'.tr(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: kColorDark
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Prefs.getString(Prefs.USER_TYPE) == 'USER' ?
                                  Text(
                                    StoreProvider.of<AppState>(context).state.vacancy.number_of_likeds != null ?
                                    StoreProvider.of<AppState>(context).state.vacancy.number_of_likeds.toString() : '0',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: kColorDark
                                    ),
                                  ) :
                                  Text(
                                    props.active_list.data != null && props.active_list.data.length > 0 ?
                                      props.active_list.data.length.toString() : '0',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          /// Go to profile likes screen
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileLikesScreen()));
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Boxicons.bx_book,
                                          size: 25,
                                          color: kColorPrimary,
                                        ),
                                        decoration:
                                        BoxDecoration(
                                            color: kColorGray,
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                            Prefs.getString(Prefs.USER_TYPE) == 'USER' ? "training".tr() : 'inactive_vacancies'.tr(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: kColorDark
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
                              Flexible(
                                child: Container(
                                  child:  Text(
                                    props.inactive_list.data != null && props.inactive_list.data.length > 0 ?
                                    props.inactive_list.data.length.toString() : '0',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),
                        onTap: () {
                          Prefs.getString(Prefs.USER_TYPE) == 'USER' ?
                          Navigator.pushNamed(context, Routes.school)
                          : Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileVisitsScreen()));
                        },
                      ),
                    ],
                  ),
                ) : Container(),

                /// App Section Card
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Text(
                              "language".tr(),
                              style: _textStyle
                          ),
                        ),
                        onTap: () {
                          /// Go to language switcher
                          Navigator.pushNamed(context, Routes.change_language);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                              "about_app".tr(),
                              style: _textStyle
                          ),
                        ),
                        onTap: () {
                          /// Go to About us
                          Navigator.pushNamed(context, Routes.about);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                              "privacy_policy".tr(),
                              style: _textStyle
                          ),
                        ),
                        onTap: () {
                          /// Go to privacy policy
                          Navigator.pushNamed(context, Routes.user_policy);
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                              "delete_account".tr(),
                              style: _textStyle
                          ),
                        ),
                        onTap: () => showOnDeleteDialog(context, 1),
                      ),

                      Prefs.getString(Prefs.USER_TYPE) == 'USER' ?
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                              "reset_settings".tr(),
                              style: _textStyle
                          ),
                        ),
                        onTap: () async {
                          user = StoreProvider.of<AppState>(context).state.user.user.data;
                          user.resetSettings(email: user.email);
                          _showDialog(context, 'successful_reset'.tr(), false);
                        },
                      ) : Container(),

                      Prefs.getString(Prefs.TOKEN) != null ?
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                              "logout".tr(),
                              style: _textStyle2
                          ),
                        ),
                        onTap: () async {
                          Prefs.setString(Prefs.EMAIL, null);
                          Prefs.setString(Prefs.PHONE_NUMBER, null);
                          Prefs.setString(Prefs.PROFILEIMAGE, null);
                          Prefs.setString(Prefs.PASSWORD, null);
                          Prefs.setString(Prefs.TOKEN, null);
                          Prefs.setString(Prefs.USER_TYPE, "USER");
                          Prefs.setString(Prefs.ROUTE, null);
                          Prefs.setInt(Prefs.USER_ID, null);
                          Prefs.setInt(Prefs.USER_STATUS, null);
                          Prefs.setInt(Prefs.NEW_MESSAGES_COUNT, 0);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.pushReplacementNamed(context, Routes.select_mode);
                        },
                      ) :
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                              "sign_in".tr(),
                              style: _textStyle2
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.pushReplacementNamed(context, Routes.select_mode);
                        },
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,
        );
      },
    );
  }

  void _showDialog(context, String message, bool error) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('continue'.tr()),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (!error){
                  // Navigator.pushReplacementNamed(context, Routes.home);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfileScreenProps {
  final Function getUser;
  final Function getUserCv;
  final Function getSubmittedNumber;
  final Function getCompanyVacancies;
  final Function getCompanyActiveVacancies;
  final Function getCompanyInactiveVacancies;
  final UserDetailState user;
  final UserCvState user_cv;
  final ListVacancysState list;
  final ListVacancysState active_list;
  final ListVacancysState inactive_list;
  final int submitted_number;

  ProfileScreenProps({
    this.getUser,
    this.user,
    this.getUserCv,
    this.user_cv,
    this.getSubmittedNumber,
    this.submitted_number,
    this.list,
    this.active_list,
    this.inactive_list,
    this.getCompanyVacancies,
    this.getCompanyActiveVacancies,
    this.getCompanyInactiveVacancies,
  });
}

ProfileScreenProps mapStateToProps(Store<AppState> store) {
  return ProfileScreenProps(
      user: store.state.vacancy.user.user,
      submitted_number: store.state.vacancy.number_of_submiteds,
      user_cv: store.state.vacancy.user.user_cv,
      list: store.state.vacancy.list,
      active_list: store.state.vacancy.active_list,
      inactive_list: store.state.vacancy.inactive_list,
      getUser: () => store.dispatch(getUser()),
      getUserCv: () => store.dispatch(getUserCv()),
      getSubmittedNumber: () => store.dispatch(getNumberOfSubmittedVacancies()),
      getCompanyVacancies: () => store.dispatch(getCompanyVacancies()),
      getCompanyActiveVacancies: () => store.dispatch(getCompanyActiveVacancies()),
      getCompanyInactiveVacancies: () => store.dispatch(getCompanyInactiveVacancies()),
  );
}
