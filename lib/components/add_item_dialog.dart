import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../datas/actions.dart';
import '../datas/vacancy.dart';

class AddItemDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Vacancy>, OnAddCallback>(
        converter: (store) {
          return (itemName) =>
              store.dispatch(AddItemAction(Vacancy(name:itemName, address:'false')));
        }, builder: (context, callback) {
      return new AddItemDialogWidget(callback);
    });
  }
}

class AddItemDialogWidget extends StatefulWidget {
  final OnAddCallback callback;

  AddItemDialogWidget(this.callback);

  @override
  State<StatefulWidget> createState() =>
      new AddItemDialogWidgetState(callback);
}

class AddItemDialogWidgetState extends State<AddItemDialogWidget> {
  String itemName;

  final OnAddCallback callback;

  AddItemDialogWidgetState(this.callback);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Item name', hintText: 'eg. Red Apples'),
              onChanged: _handleTextChanged,
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: const Text('ADD'),
            onPressed: () {
              Navigator.pop(context);
              callback(itemName);
            })
      ],
    );
  }

  _handleTextChanged(String newItemName) {
    setState(() {
      itemName = newItemName;
    });
  }
}

typedef OnAddCallback = Function(String itemName);
