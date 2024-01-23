import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:ishtapp/widgets/vacancy_card.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux/flutter_redux.dart';

class ProfileLikesScreen extends StatelessWidget {
  void handleInitialBuild(VacanciesScreenProps1 props) {
    props.getLikedVacancies();
  }

  void handleInitialBuildOfCompanyVacancy(CompanyVacanciesScreenProps props) {
    props.getCompanyActiveVacancies();
  }

  @override
  Widget build(BuildContext context) {
    return Prefs.getString(Prefs.USER_TYPE) == 'COMPANY'
        ? StoreConnector<AppState, CompanyVacanciesScreenProps>(
            converter: (store) => mapStateToVacancyProps(store),
            onInitialBuild: (props) => this.handleInitialBuildOfCompanyVacancy(props),
            builder: (context, props) {
              List<Vacancy> data = props.active_list.data;
              bool loading = props.active_list.loading;

              Widget body;
              if (loading) {
                body = Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                body = data == null || data.isEmpty ? Container() : Column(
                  children: [
                    Expanded(
                      child: StoreProvider.of<AppState>(context).state.vacancy.active_list.data !=null ?
                      Container(
                        padding: EdgeInsets.all(20),
                        child: UsersGrid(
                            children: StoreProvider.of<AppState>(context).state.vacancy.active_list.data.map((vacancy) {
                              return GestureDetector(
                                child: VacancyCard(
                                  vacancy: vacancy,
                                  page: 'company',
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return Scaffold(
                                      backgroundColor: kColorPrimary,
                                      appBar: AppBar(
                                        title: Text("vacancy_view".tr()),
                                      ),
                                      body: VacancyView(
                                        page: "company_view",
                                        vacancy: vacancy,
                                      ),
                                    );
                                  }));
                                },
                              );
                            }).toList()
                        ),
                      ) :
                      Center(
                        child: Text(
                          'empty'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Scaffold(
                backgroundColor: kColorPrimary,
                appBar: AppBar(
                  title: Text("active_vacancies".tr()),
                ),
                body: body,
              );
            },
          )
        : StoreConnector<AppState, VacanciesScreenProps1>(
            converter: (store) => mapStateToProps(store),
            onInitialBuild: (props) => this.handleInitialBuild(props),
            builder: (context, props) {
              List<Vacancy> data = props.listResponse1.data;
              bool loading = props.listResponse1.loading;
              Widget body;
              if (loading) {
                body = Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                body = Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        child: UsersGrid(
                            children: data.map((vacancy) {
                              return GestureDetector(
                                child: ProfileCard(
                                  vacancy: vacancy,
                                  page: 'match',
                                  loading: false,
                                ),
                                onTap: () {},
                              );
                            }).toList()
                        ),
                      )
                    ],
                  ),
                );
              }

              return Scaffold(
                backgroundColor: kColorPrimary,
                appBar: AppBar(
                  title: Text("likeds".tr()),
                ),
                body: body,
              );
            },
          );
  }
}

class VacanciesScreenProps1 {
  final Function getLikedVacancies;
  final LikedVacancyListState listResponse1;

  VacanciesScreenProps1({
    this.getLikedVacancies,
    this.listResponse1,
  });
}

VacanciesScreenProps1 mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps1(
    listResponse1: store.state.vacancy.liked_list,
    getLikedVacancies: () => store.dispatch(getLikedVacancies()),
  );
}

class CompanyVacanciesScreenProps {
  final Function getCompanyActiveVacancies;
  final ListVacancysState active_list;

  CompanyVacanciesScreenProps({
    this.getCompanyActiveVacancies,
    this.active_list,
  });
}

CompanyVacanciesScreenProps mapStateToVacancyProps(Store<AppState> store) {
  return CompanyVacanciesScreenProps(
    active_list: store.state.vacancy.active_list,
    getCompanyActiveVacancies: () => store.dispatch(getCompanyActiveVacancies()),
  );
}