import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ishtapp/datas/pref_manager.dart';

import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';

class ValidateCodeScreen extends StatefulWidget {
  @override
  _ValidateCodeScreenState createState() => _ValidateCodeScreenState();
}

class _ValidateCodeScreenState extends State<ValidateCodeScreen> {
  final _code_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            content: Container(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(kColorPrimary),
                  ),
                )),
          ),
        );
      },
    );
  }

  void _showDialog(context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('continue'.tr()),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: kColorPrimary,
      appBar: AppBar(
        title: Text("validate_code".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Center(
                  child: Text(
                'validate_code_info_text'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: kColorPrimary,
                  fontWeight: FontWeight.w700,
//                        fontStyle: FontStyle.italic
                ),
              )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Align(
                  widthFactor: 10,
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'code'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              TextFormField(
                controller: _code_controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (name) {
                  if (name.isEmpty) {
                    return "please_fill_this_field".tr();
                  } else if (name.length != 6) {
                    return "code_must_be_6_digit".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomButton(
                padding: EdgeInsets.all(15),
                color: kColorPrimary,
                textColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _openLoadingDialog(context);
                    Users.validateUserCode(
                            code: _code_controller.text,
                            email: Prefs.getString(Prefs.EMAIL))
                        .then((value) {
                      if (value == "OK") {
                        Navigator.pushNamed(context, Routes.new_password);
                      } else {
                        _showDialog(context,
                            "some_error_occurred_please_try_again".tr());
                      }
                    });
                  } else {
                    return;
                  }
                },
                text: 'validate'.tr(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
