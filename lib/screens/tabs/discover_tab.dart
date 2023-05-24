import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_lat_long.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/services/location_service.dart';
import 'package:ishtapp/widgets/default_card_border.dart';
import 'package:ishtapp/widgets/profile_card__map.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
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

  @override
  void initState() {
    super.initState();
    Prefs.setInt(Prefs.OFFSET, 0);
    _initPermission();
    _currentLocation();
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

  @override
  Widget build(BuildContext context) {

    return Prefs.getString(Prefs.USER_TYPE) == 'COMPANY' ?
    StoreConnector<AppState, CompanyVacanciesScreenProps>(
      converter: (store) => mapStateToVacancyProps(store),
      onInitialBuild: (props) => this.handleInitialBuildOfCompanyVacancy(props),
      builder: (context, props) {
              List<Vacancy> data = StoreProvider.of<AppState>(context).state.vacancy.list.data;
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
                    Expanded(
                      child: data != null && data.length > 0 ?
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: UsersGrid(
                            children: data.map((vacancy) {
                              return GestureDetector(
                                child: ProfileCard(vacancy: vacancy, page: 'company', offset: offset),
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
                                          page: "company_view",
                                          vacancy: vacancy,
                                          vacancySkill: vacancySkills,
                                        ),
                                      );
                                    }));
                                  });
                                },
                              );
                            }
                            ).toList()),
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
                      context: context);
                }

                if (orientation.index == CardSwipeOrientation.RIGHT.index) {
                  print('Right');
                  removeCards(
                      props: props,
                      type: "LIKED",
                      vacancyId: StoreProvider.of<AppState>(context).state.vacancy.list.data[_index].id,
                      context: context);
                }
              },
            ),
          )  :
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                "vacancies_empty".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
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
                                        child: CustomButton(
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          color: Colors.white,
                                          textColor: kColorPrimary,
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
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          color: Colors.white,
                                          textColor: kColorPrimary,
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
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: CustomButton(
                                          padding: EdgeInsets.all(0),
                                          height: 40.0,
                                          color: Colors.white,
                                          textColor: kColorPrimary,
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
                                          color: !onMap ? Colors.transparent : Colors.white,
                                          textColor: !onMap ? kColorWhite : kColorPrimary,
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
                                          color: onMap ? Colors.transparent : Colors.white,
                                          textColor: onMap ? kColorWhite : kColorPrimary,
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

  void handleInitialBuildOfCompanyVacancy(CompanyVacanciesScreenProps props) {
    props.getCompanyVacancies();
    props.getNumOfActiveVacancies();
  }
}

class CompanyVacanciesScreenProps {
  final Function getCompanyVacancies;
  final Function getNumOfActiveVacancies;
  final ListVacancysState listResponse;

  CompanyVacanciesScreenProps({
    this.getCompanyVacancies,
    this.getNumOfActiveVacancies,
    this.listResponse,
  });
}

CompanyVacanciesScreenProps mapStateToVacancyProps(Store<AppState> store) {
  return CompanyVacanciesScreenProps(
    listResponse: store.state.vacancy.list,
    getCompanyVacancies: () => store.dispatch(getCompanyVacancies()),
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
