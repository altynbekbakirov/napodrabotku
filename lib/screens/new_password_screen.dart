import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ishtapp/datas/pref_manager.dart';

import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/routes/routes.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _password_controller = TextEditingController();
  final _password_confirm_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: kColorPrimary,
      appBar: AppBar(
        title: Text("new_password_title".tr()),
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
                'new_password_info_text'.tr(),
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
                    'new_password'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              TextFormField(
                obscureText: _obscureText,
                controller: _password_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (name) {
                  // Basic validation
                  if (name.isEmpty) {
                    return "please_fill_this_field".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Align(
                  widthFactor: 10,
                  heightFactor: 1.5,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'new_password_confirm'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              TextFormField(
                controller: _password_confirm_controller,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (name) {
                  // Basic validation
                  if (name.isEmpty) {
                    return "please_fill_this_field".tr();
                  } else if (_password_confirm_controller.text != _password_controller.text) {
                    return "passwords_dont_satisfy".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomButton(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.5,
                color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                textColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Users.resetPassword(new_password: _password_controller.text, email: Prefs.getString(Prefs.EMAIL))
                        .then((value) {
                      if (value == "OK") {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushNamed(context, Routes.select_mode);
                      }
                    });
                  } else {
                    return;
                  }
                },
                text: 'reset_password'.tr(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
