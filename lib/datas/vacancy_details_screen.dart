//import 'package:flutter/material.dart';
//import 'package:ishtapp/datas/vacancy.dart';
//
//import 'package:redux/redux.dart';
//
//import 'package:flutter_redux/flutter_redux.dart';
//
//import 'app_state.dart';
//
//class VacancyDetailsScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, VacancyDetailsScreenProps>(
//      converter: (store) => mapStateToProps(store),
//      builder: (context, props) {
//        Vacancy data = props.detailsResponse.data;
//        bool loading = props.detailsResponse.loading;
//
//        TextStyle textStyle = TextStyle(
//          height: 2,
//          fontSize: 20,
//        );
//
//        Widget body;
//        if (loading) {
//          body = Center(
//            child: CircularProgressIndicator(),
//          );
//        } else {
//          body = Center(
//            child: IntrinsicWidth(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Text(data.name, style: textStyle),
//                  Text(data.title, style: textStyle),
//                  Text(data.address, style: textStyle),
//                ],
//              ),
//            ),
//          );
//        }
//
//        return Scaffold(
//          appBar: AppBar(
//            title: Text('Vacancy details'),
//          ),
//          body: body,
//        );
//      },
//    );
//  }
//}
//
//class VacancyDetailsScreenProps {
//  final VacancyDetailsState detailsResponse;
//
//  VacancyDetailsScreenProps({
//    this.detailsResponse,
//  });
//}
//
//VacancyDetailsScreenProps mapStateToProps(Store<AppState> store) {
//  return VacancyDetailsScreenProps(
//    detailsResponse: store.state.vacancy.details,
//  );
//}
