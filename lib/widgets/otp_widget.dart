import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPWidget extends StatefulWidget {
  OTPWidget({
    Key key,
  });

  @override
  OTPWidgetState createState() => OTPWidgetState();
}

class OTPWidgetState extends State<OTPWidget>
    with SingleTickerProviderStateMixin, CodeAutoFill {
  TextEditingController textEditingController = TextEditingController();

  @override
  void codeUpdated() {
    setState(() {
      textEditingController.text = code.toString();
    });
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          maxLength: 6,
          controller: textEditingController,
        ),
      ],
    );
  }
}