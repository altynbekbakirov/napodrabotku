import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> list;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(
      this.list,
      {this.onSelectionChanged} // +added
      );

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}