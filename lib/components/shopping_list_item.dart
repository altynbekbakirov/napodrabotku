import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/vacancy.dart';

import '../datas/actions.dart';

class ShoppingListItem extends StatelessWidget {
  final Vacancy item;

  ShoppingListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Vacancy>, OnStateChanged>(
        converter: (store) {
      return (item) => store.dispatch(ToggleItemStateAction(item));
    }, builder: (context, callback) {
      return new ListTile(
        title: new Text(item.name),
        leading: new Checkbox(
            value: item.address != null,
            onChanged: (bool newValue) {
              callback(Vacancy(name: item.name, address: 'sd'));
            }),
      );
    });
  }
}

typedef OnStateChanged = Function(Vacancy item);
