import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';

import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/datas/pref_manager.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  @override
  _ForgotPasswordEmailScreenState createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _email_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;

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
        title: Text("password_forgot_email".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "password_email_info_text".tr(),
                      style: TextStyle(
                          fontSize: 16,
                          color: kColorDark,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Align(
                    widthFactor: 10,
                    heightFactor: 1.5,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'email'.tr().toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                      ),
                    )
                ),
                TextFormField(
                  controller: _email_controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey[200],
                            width: 2.0
                        )
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: kColorWhite,
                  ),
                  onChanged: (value) {
                    isValid = EmailValidator.validate(value);
                  },
                  validator: (name) {
                    if (name.isEmpty) {
                      return "please_fill_this_field".tr();
                    } else if (!isValid) {
                      return "please_write_valid_email".tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                CustomButton(
                  color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ?  kColorProductLab : kColorPrimary,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _openLoadingDialog(context);
                      Users.sendMailOnForgotPassword(_email_controller.text)
                          .then((value) {
                        Prefs.setString(Prefs.EMAIL, _email_controller.text);
                        if (value == "OK") {
                          Navigator.pushNamed(context, Routes.validate_code);
                        } else {
                          _showDialog(context,
                              "some_error_occurred_please_try_again".tr());
                        }
                      });
                    } else {
                      return;
                    }
                  },
                  text: 'continue'.tr(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
