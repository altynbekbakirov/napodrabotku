import 'package:flutter/material.dart';
import 'package:ishtapp/widgets/svg_icon.dart';

import 'cicle_button.dart';
import 'default_card_border.dart';

class GalleryImageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          shape: defaultCardBorder(),
          color: Colors.grey[300],
          child: Center(
            child:
                SvgIcon("assets/icons/camera_icon.svg", width: 35, height: 35),
          ),
        ),
        Positioned(
          child: CircleButton(
              bgColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.add, color: Colors.white),
              padding: 1.0),
          right: 10,
          bottom: 10,
        )
      ],
    );
  }
}
