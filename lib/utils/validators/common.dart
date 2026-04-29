import 'package:easy_localization/easy_localization.dart';

class Validators {
  static String? faCodeValidator({String? code}) {
    if (code == "" || code == null) return null;
    if (code.length > 6) return "Неверный код".tr();
    return RegExp("[0-9]{6}").hasMatch(code) ? null : "Неверный код".tr();
  }
}
