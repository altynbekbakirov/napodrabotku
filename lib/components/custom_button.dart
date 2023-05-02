import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final double elevation;
  final int borderRadius;
  final BorderSide borderSide;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets padding;
  final double textSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final Color textColor;
  final Color color;
  final width;
  final height;

  const CustomButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.elevation,
    this.borderRadius,
    this.borderSide,
    this.mainAxisAlignment,
    this.padding,
    this.textSize,
    this.textAlign,
    this.fontWeight,
    this.textColor,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48.0,
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: elevation ?? 0,
        fillColor:color ?? kColorBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            side: borderSide ?? BorderSide(
              color: Colors.transparent,
              width: 2.0
            )
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.button.copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    fontFamily: 'Manrope'
                ),
                textAlign: textAlign ?? TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}