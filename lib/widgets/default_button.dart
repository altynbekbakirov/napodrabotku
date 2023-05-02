import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  // Variables
  final Widget child;
  final VoidCallback onPressed;
  final double width;
  final double height;

  DefaultButton({
    @required this.child, 
    @required this.onPressed, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 45,
      child: RaisedButton(
        child: child,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
