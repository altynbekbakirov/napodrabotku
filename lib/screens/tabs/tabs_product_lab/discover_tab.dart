import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:ishtapp/datas/Skill.dart';

class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> with SingleTickerProviderStateMixin {
  CardController cardController = CardController();

  void handleInitialBuild(VacanciesScreenProps props) {
    props.getVacancies();
  }

  void handleInitialBuildOfCompanyVacancy(CompanyVacanciesScreenProps props) {
    props.getCompanyVacancies();
    props.getNumOfActiveVacancies();
  }

  int button = 0;
  int offset = 5;

  @override
  void initState() {
    super.initState();
    Prefs.setInt(Prefs.OFFSET, 0);
  }

  void removeCards({String type, int vacancy_id, props, context}) {
    if (Prefs.getInt(Prefs.OFFSET) > 0 && Prefs.getInt(Prefs.OFFSET) != null) {
      offset = Prefs.getInt(Prefs.OFFSET);
    } else {
      offset = 5;
    }

    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancy_id, type: type).then((value) {
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

  bool load = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VacanciesScreenProps>(
      converter: (store) => mapStateToProps(store),
      onInitialBuild: (props) => this.handleInitialBuild(props),
      builder: (context, props) {
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
          body = data == null || data.isEmpty
              ? Container()
              : Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 25,
                    child: TinderSwapCard(
                      orientation: AmassOrientation.BOTTOM,
                      totalNum: data.length,
                      stackNum: 5,
                      swipeEdge: 5.0,
                      maxWidth: MediaQuery.of(context).size.width * 0.97,
                      maxHeight: MediaQuery.of(context).size.width * 0.97,
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      minHeight: MediaQuery.of(context).size.width * 0.96,
                      cardController: cardController,
                      cardBuilder: (context, index) {
                        _index = index;
                        return data != null && data.isNotEmpty
                            ? Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: Center(
                                      child: Text(
                                        "vacancies_empty".tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: ProfileCardProductLab(
                                      props: props,
                                      page: 'discover',
                                      vacancy: data[index],
                                      index: index,
                                      cardController: cardController,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        load = true;
                                      });
                                      VacancySkill.getVacancySkills(data[index].id).then((value) {
                                        List<VacancySkill> vacancySkills = [];

                                        for (var i in value) {
                                          vacancySkills.add(new VacancySkill(
                                            id: i.id,
                                            name: i.name,
                                            vacancyId: i.vacancyId,
                                            isRequired: i.isRequired,
                                          ));
                                        }

                                        setState(() {
                                          load = false;
                                        });

                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                          return Scaffold(
                                            backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB"
                                                ? kColorProductLab
                                                : kColorPrimary,
                                            appBar: AppBar(
                                              title: Text("vacancy_view".tr()),
                                            ),
                                            body: VacancyView(
                                              page: "view",
                                              vacancy: data[index],
                                              vacancySkill: vacancySkills,
                                            ),
                                          );
                                        }));
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Container();
                      },
                      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                        if (orientation.index == CardSwipeOrientation.LEFT.index) {
                          print('Left');
                          removeCards(
                              props: props,
                              type: "DISLIKED",
                              vacancy_id: StoreProvider.of<AppState>(context).state.vacancy.list.data[_index].id,
                              context: context);
                        }

                        if (orientation.index == CardSwipeOrientation.RIGHT.index) {
                          print('Right');
                          removeCards(
                              props: props,
                              type: "LIKED",
                              vacancy_id: StoreProvider.of<AppState>(context).state.vacancy.list.data[_index].id,
                              context: context);
                        }
                      },
                    ),
                  ),
                );
        }

        return Stack(children: [
          body,
          load
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                  ),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.lerp(new Alignment(-1.0, -1.0), new Alignment(1, -1.0), 10),
                    widthFactor: MediaQuery.of(context).size.width * 1,
                    heightFactor: MediaQuery.of(context).size.height * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.25,
                          padding: EdgeInsets.all(2),
                          color: Colors.white,
                          textColor: kColorPrimary,
                          onPressed: () {
                            Prefs.setInt(Prefs.OFFSET, 0);
                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all' : 'day'));
                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                          },
                          text:
                              StoreProvider.of<AppState>(context).state.vacancy.type == 'day' ? 'all'.tr() : 'day'.tr(),
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(2),
                          color: Colors.white,
                          textColor: kColorPrimary,
                          onPressed: () {
                            Prefs.setInt(Prefs.OFFSET, 0);
                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                type:
                                    StoreProvider.of<AppState>(context).state.vacancy.type == 'week' ? 'all' : 'week'));
                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                          },
                          text: StoreProvider.of<AppState>(context).state.vacancy.type == 'week'
                              ? 'all'.tr()
                              : 'week'.tr(),
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(2),
                          color: Colors.white,
                          textColor: kColorPrimary,
                          onPressed: () {
                            Prefs.setInt(Prefs.OFFSET, 0);
                            StoreProvider.of<AppState>(context).dispatch(setTimeFilter(
                                type: StoreProvider.of<AppState>(context).state.vacancy.type == 'month'
                                    ? 'all'
                                    : 'month'));
                            StoreProvider.of<AppState>(context).dispatch(getVacancies());
                            //                      Navigator.of(context).popAndPushNamed(Routes.signup);
                            setState(() {
                              button == 3 ? button = 0 : button = 3;
                            });
                          },
                          text: StoreProvider.of<AppState>(context).state.vacancy.type == 'month'
                              ? 'all'.tr()
                              : 'month'.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
        ]);
      },
    );
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
