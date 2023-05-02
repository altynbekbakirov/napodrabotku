import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ishtapp/utils/constants.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/datas/pref_manager.dart';

class ProductLabStart extends StatefulWidget {
  const ProductLabStart({Key key}) : super(key: key);

  @override
  _ProductLabStartScreenState createState() => _ProductLabStartScreenState();
}

class _ProductLabStartScreenState extends State<ProductLabStart> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width * 1,
                  // height: MediaQuery.of(context).size.height * 0.6,
                  child: Image.asset(
                    'assets/images/welcome_product_lab.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// Sign in with Phone Number
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Container(
                child: Text(
                  'Развивайся и зарабатывай!',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: kColorPrimary
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    padding: EdgeInsets.all(10),
                    color: Color(0xffF2F2F5),
                    textColor: kColorBlue,
                    onPressed: () {
                      Prefs.setString(Prefs.ROUTE, "PRODUCT_LAB");
                      Navigator.of(context).pushNamed(Routes.product_lab_sign_up);
                    },
                    text: 'sign_up'.tr(),
                  ),
                  CustomButton(
                    padding: EdgeInsets.all(10),
                    color: kColorProductLab,
                    textColor: Colors.white,
                    onPressed: () {
                      Prefs.setString(Prefs.ROUTE, "PRODUCT_LAB");
                      Navigator.of(context).pushNamed(Routes.signin);
                    },
                    text: 'sign_in'.tr(),
                  ),
                ],
              ),

              SizedBox(height: 10),

              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('guest'.tr(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                ),
                onTap: () {
                  Prefs.setString(Prefs.ROUTE, "PRODUCT_LAB");
                  Navigator.of(context).pushNamed(Routes.product_lab_home);
                },
              ),

              SizedBox(height: 10),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: SizedBox(
                        height: 15,
                        child: Image.asset('assets/images/partners/techaim.png'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: SizedBox(
                        height: 50,
                        child: Image.asset('assets/images/partners/htpkr.png'),
                      ),
                    ),
                    Container(
                      child: SizedBox(
                        height: 40,
                        child: Image.asset('assets/images/partners/unicef.png'),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
