import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ishtapp/screens/tabs/tabs_product_lab/discover_tab.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/widgets/cicle_button.dart';
import 'package:ishtapp/screens/tabs/matches_tab.dart';
import 'package:ishtapp/screens/tabs/profile_tab.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/widgets/badge.dart';
import 'package:ishtapp/screens/tabs/conversations_tab.dart';
import 'package:ishtapp/screens/tabs/school_tab.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';

class ProductLabHome extends StatefulWidget {
  const ProductLabHome({Key key}) : super(key: key);

  @override
  _ProductLabHomeState createState() => _ProductLabHomeState();
}

class _ProductLabHomeState extends State<ProductLabHome> {
  final _formKey = GlobalKey<FormState>();
  DateTime currentBackPressTime;
  final _pageController = new PageController();
  List<Widget> app_bar_titles = [];
  int _tabCurrentIndex = 0;
  bool is_profile = false;
  bool is_special = false;
  bool is_chat = false;
  Users user;

  List<dynamic> opportunityList = [];
  List<dynamic> opportunityTypeList = [];
  List<dynamic> opportunityDurationList = [];
  List<dynamic> internshipLanguageList = [];

  List _opportunities = [];
  List _opportunity_types = [];
  List _opportunity_durations = [];
  List _internship_languages = [];


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(context, msg: 'click_once_to_exit'.tr());
      return Future.value(false);
    }
    return Future.value(true);
  }

  getLists() async {
    opportunityList = await Vacancy.getLists('opportunity', null);
    opportunityTypeList = await Vacancy.getLists('opportunity_type', null);
    opportunityDurationList = await Vacancy.getLists('opportunity_duration', null);
    internshipLanguageList = await Vacancy.getLists('intership_language', null);
  }

  getFilters(id) async {
    _opportunities = await Users.getFilters('opportunities', id);
    _opportunity_types = await Users.getFilters('opportunity_types', id);
    _opportunity_durations = await Users.getFilters('opportunity_durations', id);
    _internship_languages = await Users.getFilters('internship_language', id);
  }

  Future<void> openFilterDialog(context) async {
    user = StoreProvider.of<AppState>(context).state.user.user.data;

    if (user != null) {
      getFilters(user.id);
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'search_filter'.tr(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          )),
                      SizedBox(
                        height: 30,
                      ),

                      /// Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'opportunity'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return '';
                              },
                              dataSource: opportunityList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _opportunities,
                              onSaved: (value) {
                                if (value == null) return;
                                print("hh");
                                print(value);
                                setState(() {
                                  _opportunities = value;
                                });
                              },
                            ),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'opportunity_type'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return '';
                              },
                              dataSource: opportunityTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _opportunity_types,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _opportunity_types = value;
                                });
                              },
                            ),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'opportunity_duration'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return '';
                              },
                              dataSource: opportunityDurationList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _opportunity_durations,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _opportunity_durations = value;
                                });
                              },
                            ),
                            MultiSelectFormField(
                              // autovalidate: AutovalidateMode.disabled,
                              title: Text(
                                'internship_language'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return '';
                              },
                              dataSource: internshipLanguageList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _internship_languages,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _internship_languages = value;
                                });
                              },
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButton(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    padding: EdgeInsets.all(10),
                                    color: Colors.grey[200],
                                    textColor: kColorPrimary,
                                    onPressed: () {
                                      setState(() {
                                        _opportunities = [];
                                        _opportunity_types = [];
                                        _opportunity_durations = [];
                                        _internship_languages = [];
                                      });

                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                        opportunity_ids: _opportunities,
                                        opportunity_type_ids: _opportunity_types,
                                        opportunity_duration_ids: _opportunity_durations,
                                        internship_language_ids: _internship_languages,
                                      ));

                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                      Navigator.of(context).pop();
                                      _nextTab(0);
                                    },
                                    text: 'change'.tr(),
                                  ),
                                  CustomButton(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    padding: EdgeInsets.all(10),
                                    color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                        opportunity_ids: _opportunities,
                                        opportunity_type_ids: _opportunity_types,
                                        opportunity_duration_ids: _opportunity_durations,
                                        internship_language_ids: _internship_languages,
                                      ));

                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                      Navigator.of(context).pop();
                                      _nextTab(0);
                                    },
                                    text: 'save'.tr(),
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

  buildSome(BuildContext context) {
    app_bar_titles = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ishtapp'.tr(),
            style:
                TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
          ),
          GestureDetector(
            child: CircleButton(
                bgColor: Colors.transparent,
                padding: 12,
                icon: Icon(
                  Boxicons.bx_filter,
                  color: Colors.white,
                  size: 35,
                )),
            onTap: () async {
              await openFilterDialog(context);
            },
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: Colors.white,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                is_profile = true;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('matches'.tr(), style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: Colors.white,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                is_profile = true;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'chat'.tr(),
            /*style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)*/
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_user,
                color: kColorPrimary,
                size: 35,
              ),
            ),
            onTap: () {
              _nextTab(4);
              setState(() {
                is_profile = true;
              });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'training'.tr(),
          ),
          GestureDetector(
            child: CircleButton(
              bgColor: Colors.transparent,
              padding: 12,
              icon: Icon(
                Boxicons.bx_atom,
                color: kColorPrimary,
                size: 35,
              ),
            ),
            onTap: () {
              // _nextTab(4, is_profile: true);
              // setState(() {
              //   is_profile = true;
              // });
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('profile'.tr(), style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    ];
  }

  void _nextTab(int tabIndex, {is_profile = false}) {
    if(tabIndex == 0) {
      StoreProvider.of<AppState>(context)
          .dispatch(getNumOfLikedVacancyRequest());
    }
    // Update tab index
    setState(() => _tabCurrentIndex = tabIndex);
    setState(() => is_profile = true);
    // Update page index
    _pageController.animateToPage(tabIndex, duration: Duration(microseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    buildSome(context);
    getLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: is_profile ? Colors.white : Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
        appBar: is_special
            ? AppBar(
                elevation: 0,
                toolbarHeight: 80,
                automaticallyImplyLeading: false,
                title: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: app_bar_titles[_tabCurrentIndex],
                ),
              )
            : AppBar(
                backgroundColor: is_profile ? Colors.white : Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                elevation: 0,
                toolbarHeight: 80,
                automaticallyImplyLeading: false,
                title: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: app_bar_titles[_tabCurrentIndex],
                ),
                actions: [],
              ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            elevation: Platform.isIOS ? 0 : 8,
            selectedItemColor: Colors.grey[600],
            selectedFontSize: _tabCurrentIndex == 4 ? 13 : 14,
            currentIndex: _tabCurrentIndex == 4 ? 0 : _tabCurrentIndex,
            onTap: (index) {
              print(index);
              _nextTab(index);
              if (index == 3 || index == 2) {
                setState(() {
                  is_special = true;
                  is_profile = true;
                });
              } else {
                setState(() {
                  is_special = false;
                  is_profile = false;
                });
              }
            },
            items: [
              Prefs.getString(Prefs.USER_TYPE) == 'COMPANY'
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        Boxicons.bx_briefcase,
                        color: _tabCurrentIndex == 0 ? kColorPrimary : null,
                      ),
                      title: Text(
                        "Главная".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : null),
                      ))
                  : BottomNavigationBarItem(
                      icon: Icon(
                        Boxicons.bx_search,
                        color: _tabCurrentIndex == 0 ? kColorPrimary : null,
                      ),
                      title: Text(
                        "Главная".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 0 ? kColorPrimary : Colors.grey),
                      )),
              Prefs.getString(Prefs.USER_TYPE) == 'COMPANY'
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        Boxicons.bx_folder,
                        color: _tabCurrentIndex == 1 ? kColorPrimary : null,
                      ),
                      title: Text(
                        "received".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                      ))
                  : BottomNavigationBarItem(
                      icon: Container(
                        width: 50,
                        height: 30,
                        child: Stack(children: [
                          Positioned(
                            top: -1.0,
                            left: 0.0,
                            right:
                                StoreProvider.of<AppState>(context).state.vacancy.number_of_likeds == null ? 0.0 : null,
                            child: Icon(
                              Boxicons.bx_like,
                              color: _tabCurrentIndex == 1 ? kColorPrimary : null,
                            ),
                          ),
                          StoreProvider.of<AppState>(context).state.vacancy.number_of_likeds == null
                              ? Container()
                              : Positioned(
                                  top: 0.0,
                                  right: 0.0,
                                  child: StoreProvider.of<AppState>(context).state.vacancy.number_of_likeds > 0
                                      ? Badge(
                                          text: StoreProvider.of<AppState>(context)
                                              .state
                                              .vacancy
                                              .number_of_likeds
                                              .toString())
                                      : Container(),
                                ),
                        ]),
                      ),
                      title: Text(
                        "matches".tr(),
                        style: TextStyle(color: _tabCurrentIndex == 1 ? kColorPrimary : Colors.grey),
                      )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_comment_detail,
                    color: _tabCurrentIndex == 2 ? kColorPrimary : null,
                  ),
                  title: Text(
                    "chat".tr(),
                    style: TextStyle(color: _tabCurrentIndex == 2 ? kColorPrimary : Colors.grey),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_book,
                    color: _tabCurrentIndex == 3 ? kColorPrimary : null,
                  ),
                  title: Text(
                    "training".tr(),
                    style: TextStyle(color: _tabCurrentIndex == 3 ? kColorPrimary : Colors.grey),
                  )),
            ],
          ),
        ),
        body: WillPopScope(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                DiscoverTab(),
                MatchesTab(),
                ConversationsTab(),
                SchoolTab(),
                ProfileTab(),
              ],
            ),
            onWillPop: onWillPop),
      ),
    );
  }
}
