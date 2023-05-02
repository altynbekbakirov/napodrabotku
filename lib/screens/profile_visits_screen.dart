import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/app_state.dart';

import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/screens/profile_screen.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/widgets/profile_card.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:ishtapp/widgets/users_grid.dart';
import 'package:ishtapp/widgets/vacancy_view.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/Skill.dart';

class ProfileVisitsScreen extends StatelessWidget {
  void handleInitialBuild(VacanciesScreenProps1 props) {
    props.getSubmittedVacancies();
  }

  void handleInitialBuildOfCompanyVacancy(
      CompanyInactiveVacanciesScreenProps props) {
    props.getCompanyVacancies();
  }

  @override
  Widget build(BuildContext context) {
    return Prefs.getString(Prefs.USER_TYPE) == 'USER'
        ? StoreConnector<AppState, VacanciesScreenProps1>(
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
                body = Column(
                  children: [
                    Expanded(
                      child: UsersGrid(
                          children: data.map((vacancy) {
                        return GestureDetector(
                          child: ProfileCard(vacancy: vacancy, page: "submit"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                                appBar: AppBar(
                                  title: Text("vacancy_view".tr()),
                                ),
                                body: VacancyView(
                                  page: "submitted",
                                  vacancy: vacancy,
                                ),
                              );
                            }));
                          },
                        );
                      }).toList()),
                    )
                  ],
                );
              }

              return Scaffold(
                backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                appBar: AppBar(
                  title: Text("visit".tr()),
                ),
                body: body,
              );
            },
          )
        : StoreConnector<AppState, CompanyInactiveVacanciesScreenProps>(
            converter: (store) => mapStateToVacancyProps(store),
            onInitialBuild: (props) =>
                this.handleInitialBuildOfCompanyVacancy(props),
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
                body = Column(
                  children: [
                    Expanded(
                      child: StoreProvider.of<AppState>(context)
                                  .state
                                  .vacancy
                                  .inactive_list
                                  .data !=
                              null
                          ? UsersGrid(
                              children: StoreProvider.of<AppState>(context)
                                  .state
                                  .vacancy
                                  .inactive_list
                                  .data
                                  .map((vacancy) {
                              return GestureDetector(
                                child: ProfileCard(
                                  vacancy: vacancy,
                                  page: 'company_inactive',
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

                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return Scaffold(
                                            backgroundColor: kColorPrimary,
                                            appBar: AppBar(
                                              title: Text("vacancy_view".tr()),
                                            ),
                                            body: VacancyView(
                                              page: "inactive",
                                              vacancy: vacancy,
                                              vacancySkill: vacancySkills,
                                            ),
                                          );
                                        }));
                                  });
                                },
                              );
                            }).toList())
                          : Center(
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
                backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                appBar: AppBar(
                  title: Text("inactive_vacancies".tr()),
                ),
                body: body,
              );
            },
          );
  }
}

class VacanciesScreenProps1 {
  final Function getSubmittedVacancies;
  final ListSubmittedVacancyState listResponse1;

  VacanciesScreenProps1({
    this.getSubmittedVacancies,
    this.listResponse1,
  });
}

VacanciesScreenProps1 mapStateToProps(Store<AppState> store) {
  return VacanciesScreenProps1(
    listResponse1: store.state.vacancy.submitted_list,
    getSubmittedVacancies: () => store.dispatch(getSubmittedVacancies()),
  );
}

class CompanyInactiveVacanciesScreenProps {
  final Function getCompanyVacancies;
  final ListVacancysState listResponse;

  CompanyInactiveVacanciesScreenProps({
    this.getCompanyVacancies,
    this.listResponse,
  });
}

CompanyInactiveVacanciesScreenProps mapStateToVacancyProps(
    Store<AppState> store) {
  return CompanyInactiveVacanciesScreenProps(
    listResponse: store.state.vacancy.inactive_list,
    getCompanyVacancies: () => store.dispatch(getCompanyInactiveVacancies()),
  );
}
