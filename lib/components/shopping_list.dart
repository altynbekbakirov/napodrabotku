import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/components/shopping_list_item.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Vacancy>, List<Vacancy>>(
      converter: (store) => store.state,
      builder: (context, list) {
        return new ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, position) =>
                new ShoppingListItem(list[position]));
      },
    );
  }
}
