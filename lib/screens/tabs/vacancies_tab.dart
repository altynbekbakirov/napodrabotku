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

class VacanciesTab extends StatelessWidget {
  void handleInitialBuild(VacanciesScreenProps1 props) {
    props.getSubmittedVacancies();
  }

  void handleInitialBuildOfCompanyVacancy(
      CompanyInactiveVacanciesScreenProps props) {
    props.getCompanyVacancies();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VacanciesScreenProps1>(
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  Flex(
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        child: UsersGrid(
                            children: data.map((vacancy) {
                              return GestureDetector(
                                child: Container(
                                    child: ProfileCard(vacancy: vacancy, page: "submit")
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Scaffold(
                                              backgroundColor: kColorPrimary,
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
                            }).toList()
                        ),
                      )
                    ],
                  ),
                );
              }

              return Scaffold(
                backgroundColor: kColorPrimary,
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
