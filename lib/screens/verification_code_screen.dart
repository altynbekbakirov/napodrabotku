import 'package:flutter/material.dart';
import 'package:ishtapp/screens/sign_up_screen.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:otp_screen/otp_screen.dart';

class VerificationCodeScreen extends StatelessWidget {
  /// logic to validate otp return [null] when success else error [String]
  Future<String> validateOtp(String otp) async {
    return null;

    /// Handle entered verification code here
    // await Future.delayed(Duration(milliseconds: 5000));
    // if (otp == "123456") {
    //   return null;
    // } else {
    //   return "The entered code is wrong";
    // }
  }

  /// action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    /// Go to sign up screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return OtpScreen.withGradientBackground(
      topColor: Theme.of(context).primaryColor,
      bottomColor: Theme.of(context).primaryColor.withOpacity(.7),
      otpLength: 6,
      validateOtp: validateOtp,
      routeCallback: moveToNextScreen,
      icon: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: SvgIcon("assets/icons/phone_icon.svg",
            width: 40, height: 40, color: Theme.of(context).primaryColor),
      ),
      subTitle: "Please enter the SMS code sent\n to your device",
    );
  }
}
