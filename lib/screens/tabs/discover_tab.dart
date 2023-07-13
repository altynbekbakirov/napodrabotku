import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_lat_long.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/services/location_service.dart';
import 'package:ishtapp/widgets/default_card_border.dart';
import 'package:ishtapp/widgets/profile_card__map.dart';
import 'package:ishtapp/widgets/profile_card_user.dart';
import 'package:ishtapp/widgets/user_view.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:http/http.dart' as http;

import 'package:ishtapp/datas/Skill.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> with SingleTickerProviderStateMixin {
  CardController cardController = CardController();

  // yandex maps
  Completer<YandexMapController> _controller = Completer();
  YandexMapController _yandexMapController;
  Point _point;
  AppLatLong _appLatLong;
  Placemark _placemark;

  int button = 0;
  int offset = 5;
  bool onMap = false;

  Users user;
  int user_id;

  List<dynamic> jobTypeList = [];
  List<dynamic> vacancyTypeList = [];
  List<dynamic> busynessList = [];
  List<dynamic> scheduleList = [];
  List<dynamic> regionList = [];
  List<dynamic> districtList = [];
  List<dynamic> currencyList = [];

  List<String> regions = [];
  List<String> districts = [];

  List _jobTypes = [];
  List _vacancyTypes = [];
  List _businesses = [];
  List _schedules = [];
  List _regions = [];
  List _districts = [];

  int _regionId;

  TextEditingController _typeAheadController = TextEditingController();
  List<dynamic> _suggestions = [];
  String _selectedCity;

  final _formKey = GlobalKey<FormState>();

  getLists() async {
    regionList = await Vacancy.getLists('region', null);
    jobTypeList = await Vacancy.getLists('job_type', null);
    vacancyTypeList = await Vacancy.getLists('vacancy_type', null);
    busynessList = await Vacancy.getLists('busyness', null);
    scheduleList = await Vacancy.getLists('schedule', null);
    districtList = await Vacancy.getLists('districts', null);
    await Vacancy.getLists('region', null).then((value) {
      value.forEach((region) {
        regions.add(region["name"]);
      });
    });
    currencyList = await Vacancy.getLists('currencies', null);
  }

  Future<void> openVacancyDialog(context, props, Vacancy vacancy) async {

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              shape: defaultCardBorder(),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                width: double.maxFinite,
                child: GestureDetector(
                  child: ProfileCardMap(
                    props: props,
                    page: 'discover',
                    vacancy: vacancy,
                    cardController: cardController,
                  ),
                  onTap: () {
                    VacancySkill.getVacancySkills(vacancy.id).then((value) {
                      List<VacancySkill> vacancySkills = [];

                      for (var i in value) {
                        vacancySkills.add(new VacancySkill(
                          id: i.id,
                          name: i.name,
                          vacancyId: i.vacancyId,
                          isRequired: i.isRequired,
                        ));
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return Scaffold(
                          backgroundColor: kColorPrimary,
                          appBar: AppBar(
                            title: Text("vacancy_view".tr()),
                          ),
                          body: VacancyView(
                            page: "view",
                            vacancy: vacancy,
                            vacancySkill: vacancySkills,
                          ),
                        );
                      }));
                    });
                  },
                ),
              ),
            );
          });
        });
  }

  getFilters(id) async {
    _jobTypes = await Users.getFilters('activities', id);
    _vacancyTypes = await Users.getFilters('types', id);
    _businesses = await Users.getFilters('busyness', id);
    _schedules = await Users.getFilters('schedules', id);
    _regions = await Users.getFilters('regions', id);
    // _districts = await User.getFilters('districts', id);
  }

  Future<void> openFilterDialog(context) async {
    user_id = Prefs.getInt(Prefs.USER_ID);
    if (user_id != null) {
      getFilters(Prefs.getInt(Prefs.USER_ID));
    }

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Flex(
                                direction: Axis.vertical,
                                children: [
                                  Align(
                                      widthFactor: 10,
                                      heightFactor: 1.5,
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'location'.tr().toString().toUpperCase(),
                                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                  TypeAheadFormField(
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: _typeAheadController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor: kColorWhite,
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      print(pattern);
                                      if(pattern.length > 3) {
                                        _suggestions = await _fetchAddressSuggestions(pattern);
                                      }
                                      return _suggestions;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion['value']),
                                      );
                                    },
                                    noItemsFoundBuilder: (context) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Text(
                                          'address_not_found'.tr(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54
                                          ),
                                        ),
                                      );
                                    },
                                    transitionBuilder: (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) async {
                                      _regions = [];
                                      _typeAheadController.text = suggestion['value'];

                                      String region = suggestion['data']['region_with_type'];
                                      double latitude = double.parse(suggestion['data']['geo_lat']);
                                      double longitude = double.parse(suggestion['data']['geo_lon']);

                                      if(region != '' && region != null){
                                        int regionId = await Vacancy.getRegionByName(region);
                                        setState(() {
                                          this._regions.add(regionId);
                                          this._point = Point(
                                              latitude: latitude,
                                              longitude: longitude
                                          );
                                        });
                                      }

                                      print(_regions);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Введите адрес';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _selectedCity = value,
                                  ),
                                ],
                              ),
                            ),
                            MultiSelectFormField(
                              fillColor: kColorWhite,
                              title: Text(
                                'job_types'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              chipLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kColorPrimary),
                              chipBackGroundColor: kColorPrimary.withOpacity(0.25),
                              dialogTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: jobTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _jobTypes,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _jobTypes = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              fillColor: kColorWhite,
                              title: Text(
                                'vacancy_types'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: vacancyTypeList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _vacancyTypes,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _vacancyTypes = value;
                                });
                              },
                            ),
//                          SizedBox(height: 20),
                            MultiSelectFormField(
                              fillColor: kColorWhite,
                              title: Text(
                                'businesses'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: busynessList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _businesses,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _businesses = value;
                                });
                              },
                            ),
                            MultiSelectFormField(
                              fillColor: kColorWhite,
                              title: Text(
                                'schedules'.tr(),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'select_one_or_more'.tr();
                                }
                                return null;
                              },
                              dataSource: scheduleList,
                              textField: 'name',
                              valueField: 'id',
                              okButtonLabel: 'ok'.tr(),
                              cancelButtonLabel: 'cancel'.tr(),
                              // required: true,
                              hintWidget: Text('select_one_or_more'.tr()),
                              initialValue: _schedules,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _schedules = value;
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
                                    borderSide: BorderSide(
                                        color: kColorPrimary,
                                        width: 2.0
                                    ),
                                    color: Colors.transparent,
                                    textColor: kColorPrimary,
                                    onPressed: () {


                                      setState(() {
                                        _typeAheadController.text = '';
                                        _suggestions = [];
                                        _regionId = null;
                                        _regions = [];
                                        _districts = [];
                                        _jobTypes = [];
                                        _vacancyTypes = [];
                                        _businesses = [];
                                        _schedules = [];
                                      });

                                      if (user != null) {
                                        user.saveFilters(_regions, _districts, _jobTypes, _vacancyTypes, _businesses, _schedules);
                                      }

                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                          schedule_ids: _schedules,
                                          busyness_ids: _businesses,
                                          region_ids: [_regionId],
                                          district_ids: _districts,
                                          vacancy_type_ids: _vacancyTypes,
                                          job_type_ids: _jobTypes)
                                      );

                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());

                                      Navigator.of(context).pop();
                                      // _nextTab(0);
                                    },
                                    text: 'reset'.tr(),
                                  ),
                                  CustomButton(
                                    color: kColorPrimary,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (user != null) {
                                        user.saveFilters(_regions, _districts, _jobTypes, _vacancyTypes, _businesses, _schedules);
                                      }
                                      StoreProvider.of<AppState>(context).dispatch(setFilter(
                                          schedule_ids: _schedules,
                                          busyness_ids: _businesses,
                                          // region_ids: [_regionId],
                                          region_ids: _regions,
                                          district_ids: _districts,
                                          vacancy_type_ids: _vacancyTypes,
                                          job_type_ids: _jobTypes)
                                      );
                                      StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                      Navigator.of(context).pop();
                                      (await _controller.future).move(
                                        point: _point,
                                        animation: const MapAnimation(smooth: true, duration: 1),
                                        zoom: 8,
                                      );
                                      // _nextTab(0);
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

  @override
  void initState() {
    getLists();

    super.initState();
    Prefs.setInt(Prefs.OFFSET, 0);

    if (Prefs.getString(Prefs.ROUTE) != 'COMPANY') {
      _currentLocation();
      _initPermission();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?

    StoreConnector<AppState, UsersScreenProps>(
      converter: (store) => mapStateToUsersProps(store),
      onInitialBuild: (props) => this.handleInitialBuildOfUsers(props),
      builder: (context, props) {
              List<Users> data = StoreProvider.of<AppState>(context).state.user.list.data;
              // List<Users> data = props.listResponse.data;
              // List<Vacancy> data = StoreProvider.of<AppState>(context).state.vacancy.list.data;
              bool loading = props.listResponse.loading;

              Widget body;
              if (loading) {
                body = Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                body = Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        // color: kColorGray,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  child: RawMaterialButton(
                                      onPressed: () async {
                                        Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? await openFilterDialog(context) : await openFilterDialog(context);
                                      },
                                      elevation: 0,
                                      fillColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          side: BorderSide(
                                              color: Colors.white,
                                              width: 2.0
                                          )
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Boxicons.bx_filter,
                                              color: Colors.white,
                                              size: 24,
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                  onTap: () async {
                                    // Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? await openVacancyForm(context) : await openFilterDialog(context);
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorWhite,
                                      width: 2.0
                                  ),
                                  color: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? Colors.white : Colors.transparent,
                                  textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? kColorPrimary : Colors.white,
                                  textSize: 14,
                                  padding: EdgeInsets.all(0),
                                  height: 40.0,
                                  onPressed: () {
                                    Prefs.setInt(Prefs.OFFSET, 0);
                                    StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                        type: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all' : 'day'));
                                    StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                  },
                                  text: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all'.tr() : 'day'.tr(),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorWhite,
                                      width: 2.0
                                  ),
                                  color: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? Colors.white : Colors.transparent,
                                  textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? kColorPrimary : Colors.white,
                                  textSize: 14,
                                  padding: EdgeInsets.all(0),
                                  height: 40.0,
                                  onPressed: () {
                                    Prefs.setInt(Prefs.OFFSET, 0);
                                    StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                        type: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all' : 'week')
                                    );
                                    StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                  },
                                  text: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all'.tr() : 'week'.tr(),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomButton(
                                  borderSide: BorderSide(
                                      color: kColorWhite,
                                      width: 2.0
                                  ),
                                  color: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? Colors.white : Colors.transparent,
                                  textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? kColorPrimary : Colors.white,
                                  textSize: 14,
                                  padding: EdgeInsets.all(0),
                                  height: 40.0,
                                  onPressed: () {
                                    Prefs.setInt(Prefs.OFFSET, 0);
                                    StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                        type: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? 'all' : 'month'));
                                    StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                    setState(() {
                                      button == 3 ? button = 0 : button = 3;
                                    });
                                  },
                                  text: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? 'all'.tr() : 'month'.tr(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 15,
                      child: data != null && data.length > 0 ?
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: UsersGrid(
                            children: data.map((user) {
                              return GestureDetector(
                                child: ProfileCardUser(user: user, page: 'company_home', props: props,),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: kColorPrimary,
                                      appBar: AppBar(
                                        title: Text('vacancy_view'.tr()),
                                      ),
                                      body: UserView(
                                        page: 'company_home',
                                        user: user
                                      ),
                                    );
                                  }));
                                },
                              );
                            }).toList()
                        ),
                      ) :
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Center(
                          child: Text(
                            'company_vacancies_empty'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return body;
            },
    ) :
    StoreConnector<AppState, VacanciesScreenProps>(
      converter: (store) => mapStateToProps(store),
      onInitialBuild: (props) => this.handleInitialBuild(props),
      builder: (context, props)  {
        List<Vacancy> data = props.listResponse.data;
        bool loading = props.listResponse.loading;

        Widget body;
        if (loading) {
          body = Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {
          var _index = 0;
          body = onMap ?
          Container(
            color: kColorGray,
            child: Stack(
              children: [
                YandexMap(
                  onMapCreated: (YandexMapController controller) async {
                    _yandexMapController = controller;

                    for (var i = 0; i < data.length; i++) {
                      if(data[i].latitude != null && data[i].longitude != null){
                        await _yandexMapController.addPlacemark(
                            Placemark(
                                point: Point(
                                    latitude: double.parse(data[i].latitude),
                                    longitude: double.parse(data[i].longitude)
                                ),
                                style: PlacemarkStyle(
                                    iconName: 'assets/marker.png',
                                    opacity: 1.0
                                ),
                                onTap: (Point point) {
                                  openVacancyDialog(context, props, data[i]);
                                }
                            )
                        );
                      }
                    }

                    await _yandexMapController.move(
                        point: _point,
                        animation: const MapAnimation(smooth: true, duration: 2.0),
                        zoom: 8
                    );
                  },
                ),
                Positioned(
                    right: 10.0,
                    bottom: 10.0,
                    child: new Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        child: Icon(
                          Boxicons.bx_navigation,
                          color: kColorPrimary,
                        ),
                        onTap: () async {
                          await _yandexMapController.move(
                              point: _point,
                              animation: const MapAnimation(smooth: true, duration: 2.0),
                              zoom: 8
                          );
                        },
                      ),
                    )
                ),
              ],
            ),
          ) : data != null && data.isNotEmpty ?
          Container(
            // color: kColorProductLab,
            padding: EdgeInsets.only(bottom: 10),
            child: TinderSwapCard(
              orientation: AmassOrientation.BOTTOM,
              totalNum: data.length,
              swipeUp: false,
              stackNum: 4,
              swipeEdge: 5.0,
              maxWidth: MediaQuery.of(context).size.width * 0.96,
              maxHeight: MediaQuery.of(context).size.width * 0.85,
              minWidth: MediaQuery.of(context).size.width * 0.72,
              minHeight: MediaQuery.of(context).size.width * 0.82,
              cardController: cardController,
              cardBuilder: (context, index) {
                _index = index;
                return data != null && data.isNotEmpty ?
                Container(
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: ProfileCard(
                          props: props,
                          page: 'discover',
                          vacancy: StoreProvider.of<AppState>(context).state.vacancy.list.data[index],
                          index: index,
                          cardController: cardController,
                        ),
                        onTap: () {
                          VacancySkill.getVacancySkills(StoreProvider.of<AppState>(context).state.vacancy.list.data[index].id).then((value) {
                            List<VacancySkill> vacancySkills = [];

                            for (var i in value) {
                              vacancySkills.add(new VacancySkill(
                                id: i.id,
                                name: i.name,
                                vacancyId: i.vacancyId,
                                isRequired: i.isRequired,
                              ));
                            }
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: kColorPrimary,
                                appBar: AppBar(
                                  title: Text("vacancy_view".tr()),
                                ),
                                body: VacancyView(
                                  page: "view",
                                  vacancy: StoreProvider.of<AppState>(context).state.vacancy.list.data[index],
                                  vacancySkill: vacancySkills,
                                ),
                              );
                            }));
                          });
                        },
                      ),
                    ],
                  ),
                ) : Container();
              },
              swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                if (orientation.index == CardSwipeOrientation.LEFT.index) {
                  print('Left');
                  removeCards(
                      props: props,
                      type: "DISLIKED",
                      vacancyId: StoreProvider.of<AppState>(context).state.vacancy.list.data[_index].id,
                      context: context
                  );
                }

                if (orientation.index == CardSwipeOrientation.RIGHT.index) {
                  print('Right');
                  removeCards(
                      props: props,
                      type: "LIKED",
                      vacancyId: StoreProvider.of<AppState>(context).state.vacancy.list.data[_index].id,
                      context: context
                  );
                }
              },
            ),
          )  :
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "vacancies_empty".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Users.resetDislikedVacancies().then((value) {
                        StoreProvider.of<AppState>(context).dispatch(getVacancies());
                      });
                    },
                    child: Text(
                      "show_again".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: kColorWhite,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationThickness: 3
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        }

        return Container(
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    // color: kColorGray,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            // color: kColorGray,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: GestureDetector(
                                          child: RawMaterialButton(
                                              onPressed: () async {
                                                Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? await openFilterDialog(context) : await openFilterDialog(context);
                                              },
                                              elevation: 0,
                                              fillColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  side: BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0
                                                  )
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? Boxicons.bxs_plus_square : Boxicons.bx_filter,
                                                      color: Colors.white,
                                                      size: 24,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),
                                          onTap: () async {
                                            // Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ? await openVacancyForm(context) : await openFilterDialog(context);
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 2.0
                                          ),
                                          color: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? Colors.white : Colors.transparent,
                                          textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? kColorPrimary : Colors.white,
                                          textSize: 14,
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          onPressed: () {
                                            Prefs.setInt(Prefs.OFFSET, 0);
                                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all' : 'day'));
                                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                          },
                                          text: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all'.tr() : 'day'.tr(),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 2.0
                                          ),
                                          color: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? Colors.white : Colors.transparent,
                                          textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? kColorPrimary : Colors.white,
                                          textSize: 14,
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          onPressed: () {
                                            Prefs.setInt(Prefs.OFFSET, 0);
                                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all' : 'week')
                                            );
                                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                          },
                                          text: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all'.tr() : 'week'.tr(),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 2.0
                                          ),
                                          color: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? Colors.white : Colors.transparent,
                                          textColor: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? kColorPrimary : Colors.white,
                                          textSize: 14,
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          onPressed: () {
                                            Prefs.setInt(Prefs.OFFSET, 0);
                                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? 'all' : 'month'));
                                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                                            setState(() {
                                              button == 3 ? button = 0 : button = 3;
                                            });
                                          },
                                          text: StoreProvider.of<AppState>(context).state.vacancy.type == 'month' ? 'all'.tr() : 'month'.tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            // color: kColorProductLab,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 2.0,
                                          ),
                                          height: 40.0,
                                          padding: EdgeInsets.all(0),
                                          color: !onMap ? Colors.white : Colors.transparent,
                                          textColor: !onMap ? kColorPrimary : kColorWhite,
                                          onPressed: () {
                                            setState(() {
                                              onMap = false;
                                            });
                                            Prefs.setInt(Prefs.OFFSET, 0);
                                            /*StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all' : 'day'));
                                            StoreProvider.of<AppState>(context).dispatch(getVacancies());*/
                                          },
                                          text: 'list'.tr(),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          borderSide: BorderSide(
                                              color: kColorWhite,
                                              width: 2.0
                                          ),
                                          height: 40.0,
                                          padding: EdgeInsets.all(0),
                                          color: onMap ? Colors.white : Colors.transparent,
                                          textColor: onMap ? kColorPrimary : kColorWhite,
                                          onPressed: () {
                                            setState(() {
                                              onMap = true;
                                            });
                                            Prefs.setInt(Prefs.OFFSET, 0);
                                            /*StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all' : 'week')
                                            );
                                            StoreProvider.of<AppState>(context).dispatch(getVacancies());*/
                                          },
                                          text: 'on_the_map'.tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    // color: kColorSecondary,
                    child: body,
                  ),
                )
              ]
          ),
        );
      },
    );
  }

  Future<List<dynamic>> _fetchAddressSuggestions(String pattern) async {
    List<dynamic> suggestions = [];
    String token = "132a62a4c888a776c87241ed9e615638651f14a8";

    if(pattern.length > 3) {
      final response = await http.post(
        Uri.parse('https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token ' + token
        },
        body: jsonEncode(<String, String>{
          'query': pattern,
          'count': '3'
        }),
      );

      if (response.statusCode == 200) {
        Map<dynamic, dynamic> responseData = json.decode(response.body);
        for(int i = 0; i < responseData['suggestions'].length; i++) {
          suggestions.add(responseData['suggestions'][i]);
        }
      } else {
        throw Exception('Не удается найти адрес.');
      }

    }
    return suggestions;
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
  }

  Future<void> _currentLocation() async {
    AppLatLong appLatLong;
    try {
      appLatLong = await LocationService().getCurrentLocation();
    } catch (_) {
      appLatLong = MoscowLocation();
    }

    setState(() {
      _point = Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long
      );
    });
  }

  void removeCards({String type, int vacancyId, props, context}) {
    if (Prefs.getInt(Prefs.OFFSET) > 0 && Prefs.getInt(Prefs.OFFSET) != null) {
      offset = Prefs.getInt(Prefs.OFFSET);
    } else {
      offset = 5;
    }

    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancyId, type: type).then((value) {
        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
      });
      setState(() {
        props.listResponse.data.remove(props.listResponse.data[0]);
      });
    } else {
      setState(() {
        props.listResponse.data.remove(props.listResponse.data[0]);
      });
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
        Prefs.setInt(Prefs.OFFSET, offset);
        setState(() {
          props.listResponse.data.add(value);
        });
      }
    });
  }

  void handleInitialBuild(VacanciesScreenProps props) {
    props.getVacancies();
  }

  void handleInitialBuildOfUsers(UsersScreenProps props) {
    props.getUsers();
  }

  void handleInitialBuildOfCompanyVacancy(CompanyVacanciesScreenProps props) {
    props.getCompanyVacancies();
    props.getNumOfActiveVacancies();
  }
}

class UsersScreenProps {
  final Function getUsers;
  final ListUsersState listResponse;

  UsersScreenProps({
    this.getUsers,
    this.listResponse,
  });
}

UsersScreenProps mapStateToUsersProps(Store<AppState> store) {
  return UsersScreenProps(
    listResponse: store.state.user.list,
    getUsers: () => store.dispatch(getUsers()),
  );
}

class CompanyVacanciesScreenProps {
  final Function getCompanyVacancies;
  final Function getCompanyActiveVacancies;
  final Function getNumOfActiveVacancies;
  final ListVacancysState listResponse;

  CompanyVacanciesScreenProps({
    this.getCompanyVacancies,
    this.getCompanyActiveVacancies,
    this.getNumOfActiveVacancies,
    this.listResponse,
  });
}

CompanyVacanciesScreenProps mapStateToVacancyProps(Store<AppState> store) {
  return CompanyVacanciesScreenProps(
    listResponse: store.state.vacancy.list,
    getCompanyVacancies: () => store.dispatch(getCompanyVacancies()),
    getCompanyActiveVacancies: () => store.dispatch(getCompanyActiveVacancies()),
    getNumOfActiveVacancies: () => store.dispatch(getNumberOfActiveVacancies()),
  );
}

class VacanciesScreenProps {
  final Function getVacancies;
  final Function deleteItem;
  final Function addOneToMatches;
  final ListVacancysState listResponse;

  VacanciesScreenProps({this.getVacancies, this.listResponse, this.deleteItem, this.addOneToMatches});
}

VacanciesScreenProps mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps(
    listResponse: store.state.vacancy.list,
    addOneToMatches: () => store.dispatch(getNumberOfLikedVacancies()),
    getVacancies: () => store.dispatch(getVacancies()),
    deleteItem: () => store.dispatch(deleteItem1()),
  );
}
