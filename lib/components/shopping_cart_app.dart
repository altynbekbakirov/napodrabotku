import 'package:flutter/material.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/components/shopping_list.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'add_item_dialog.dart';

class ShoppingCartApp extends StatelessWidget {
  final DevToolsStore<List<Vacancy>> store;

  ShoppingCartApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ShoppingCart',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ShoppingCart(store),
    );
  }
}

class ShoppingCart extends StatelessWidget {
  final DevToolsStore<List<Vacancy>> store;

  ShoppingCart(this.store);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ShoppingCart'),
      ),
      body: new ShoppingList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _openAddItemDialog(context),
        child: new Icon(Icons.add),
      ),
      endDrawer: new Container(
          width: 240.0, color: Colors.white, child: new ReduxDevTools(store)),
    );
  }
}

_openAddItemDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => new AddItemDialog());
}
