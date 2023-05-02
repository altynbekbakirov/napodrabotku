import 'package:flutter/material.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/datas/pref_manager.dart';

/// Класс Модальных окон
class Dialogs {
  /// Диалоговое окно загрузки
  static openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Container(
                color: Colors.transparent,
                height: 50,
                width: 50,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(kColorPrimary),
                ))),
          ),
        );
      },
    );
  }

  /// Всплывающее диалоговое окно
  static showDialogBox(context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('okay'.tr()),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  /// Диалоговое окно Удаления
  static showOnDeleteDialog(context, String message, Vacancy vacancy) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        heightFactor: 1 / 2,
        child: AlertDialog(
          backgroundColor: kColorWhite,
          title: Text(''),
          content: Text(
            message,
            style: TextStyle(color: kColorPrimary),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'no'.tr(),
                style: TextStyle(color: kColorDark),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text(
                'yes'.tr(),
                style: TextStyle(color: kColorPrimary),
              ),
              onPressed: () {
                Vacancy.deleteCompanyVacancy(
                  vacancy_id: vacancy.id,
                ).then((value) {
                  StoreProvider.of<AppState>(context).state.vacancy.list.data.remove(vacancy);
                  // StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                  StoreProvider.of<AppState>(context).dispatch(getNumberOfActiveVacancies());
                  StoreProvider.of<AppState>(context).dispatch(getNumberOfInactiveVacancies());
                  Navigator.of(ctx).pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Диалоговое окно Деактивации
  static showOnDeactivateDialog(context, String message, bool active, Vacancy vacancy) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        heightFactor: 1 / 2,
        child: AlertDialog(
          backgroundColor: kColorWhite,
          title: Text(''),
          content: Text(
            message,
            style: TextStyle(color: kColorPrimary),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'no'.tr(),
                style: TextStyle(color: kColorDark),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
//                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text(
                'yes'.tr(),
                style: TextStyle(color: kColorPrimary),
              ),
              onPressed: () {
                Vacancy.activateDeactiveVacancy(vacancy_id: vacancy.id, active: active).then((value) {
//                  StoreProvider.of<AppState>(context).dispatch(getCompanyVacancies());
                  StoreProvider.of<AppState>(context).dispatch(getNumberOfActiveVacancies());
                  StoreProvider.of<AppState>(context).dispatch(getNumberOfInactiveVacancies());
                  if (active)
                    StoreProvider.of<AppState>(context).state.vacancy.inactive_list.data.remove(vacancy);
                  else
                    StoreProvider.of<AppState>(context).state.vacancy.list.data.remove(vacancy);
//                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeCards({String type, int vacancy_id, props, context, int offset}) {
    if (Prefs.getString(Prefs.TOKEN) != null) {
      if (type == "LIKED") {
        props.addOneToMatches();
      }
      Vacancy.saveVacancyUser(vacancy_id: vacancy_id, type: type).then((value) {
        StoreProvider.of<AppState>(context).dispatch(getNumberOfLikedVacancies());
      });
      props.listResponse.data.removeLast();
    } else {
      props.listResponse.data.removeLast();
    }
    Vacancy.getVacancyByOffset(
            offset: offset,
            job_type_ids: StoreProvider.of<AppState>(context).state.vacancy.job_type_ids,
            region_ids: StoreProvider.of<AppState>(context).state.vacancy.region_ids,
            schedule_ids: StoreProvider.of<AppState>(context).state.vacancy.schedule_ids,
            busyness_ids: StoreProvider.of<AppState>(context).state.vacancy.busyness_ids,
            vacancy_type_ids: StoreProvider.of<AppState>(context).state.vacancy.vacancy_type_ids,
            type: StoreProvider.of<AppState>(context).state.vacancy.type)
        .then(
      (value) {
        if (value != null) {
          offset = offset + 1;
          props.listResponse.data.insert(0, value);
        }
      },
    );
  }
}
