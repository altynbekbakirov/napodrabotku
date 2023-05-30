import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ishtapp/routes/routes.dart';
import 'package:ishtapp/screens/change_language_screen.dart';
import 'package:ishtapp/screens/edit_profile_screen.dart';
import 'package:ishtapp/screens/home_screen.dart';
import 'package:ishtapp/screens/otp_sms_screen.dart';
import 'package:ishtapp/screens/profile_screen.dart';
import 'package:ishtapp/screens/school_screen.dart';
import 'package:ishtapp/screens/sign_in_screen.dart';
import 'package:ishtapp/screens/sign_up_screen.dart';
import 'package:ishtapp/screens/start_screen.dart';
import 'package:ishtapp/screens/splash_screen.dart';
import 'package:ishtapp/screens/choose_language.dart';
import 'package:ishtapp/screens/about_screen.dart';
import 'package:ishtapp/screens/user_policy_screen.dart';
import 'package:ishtapp/screens/validate_code_screen.dart';
import 'package:ishtapp/screens/forgot_password_email_screen.dart';
import 'package:ishtapp/screens/new_password_screen.dart';
import 'package:ishtapp/screens/select_mode_screen.dart';
import 'package:ishtapp/screens/edit_vacancy.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => SplashScreen());

      case Routes.chooseLanguage:
        return CupertinoPageRoute(builder: (_) => ChooseLanguageScreen());

      case Routes.start:
        return CupertinoPageRoute(builder: (_) => StartScreen());

      case Routes.signin:
        return CupertinoPageRoute(builder: (_) => SignInScreen());

      case Routes.signup:
        return CupertinoPageRoute(builder: (_) => SignUpScreen());

      case Routes.home:
        return CupertinoPageRoute(builder: (_) => HomeScreen());

      case Routes.change_language:
        return CupertinoPageRoute(builder: (_) => ChangeLanguageScreen());

      case Routes.user_details:
        return CupertinoPageRoute(builder: (_) => ProfileScreen());

      case Routes.user_edit:
        return CupertinoPageRoute(builder: (_) => EditProfileScreen());

      case Routes.validate_code:
        return CupertinoPageRoute(builder: (_) => ValidateCodeScreen());

      case Routes.forgot_password:
        return CupertinoPageRoute(builder: (_) => ForgotPasswordEmailScreen());

      case Routes.new_password:
        return CupertinoPageRoute(builder: (_) => NewPasswordScreen());

      case Routes.profile:
        return CupertinoPageRoute(builder: (_) => ProfileScreen());

      case Routes.about:
        return CupertinoPageRoute(builder: (_) => AboutScreen());

      case Routes.user_policy:
        return CupertinoPageRoute(builder: (_) => UserPolicyScreen());

      case Routes.select_mode:
        return CupertinoPageRoute(builder: (_) => SelectMode());

      case Routes.edit_vacancy:
        return CupertinoPageRoute(builder: (_) => EditVacancy());

      case Routes.school:
        return CupertinoPageRoute(builder: (_) => SchoolScreen());

      case Routes.error:
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('new_page'.tr()),
        ),
        body: Center(
          child: Text('new_page'.tr()),
        ),
      );
    });
  }
}
