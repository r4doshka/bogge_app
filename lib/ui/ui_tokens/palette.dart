import 'package:flutter/material.dart';

class AppPalette {
  final Color primary;
  final Color primary60;
  final Color primary30;
  final Color primary12;
  final Color primaryDark;

  final Color secondary;
  final Color secondary60;
  final Color secondary30;
  final Color secondary12;
  final Color secondaryDark;

  final Color peach;
  final Color peach60;
  final Color peach30;
  final Color peach12;
  final Color cancelDark;

  final Color text;
  final Color text60;
  final Color text30;
  final Color text12;

  final Color white;
  final Color white60;
  final Color white30;
  final Color white12;

  final Color brown;
  final Color brownMiddle;
  final Color brownDark;

  final Color gray;
  final Color gray2;
  final Color gray3;

  final Color bgLight;
  final Color bgDark;

  final Color delete;

  const AppPalette({
    required this.primary,
    required this.primary60,
    required this.primary30,
    required this.primary12,
    required this.primaryDark,
    required this.secondary,
    required this.secondary60,
    required this.secondary30,
    required this.secondary12,
    required this.secondaryDark,
    required this.peach,
    required this.peach60,
    required this.peach30,
    required this.peach12,
    required this.cancelDark,
    required this.text,
    required this.text60,
    required this.text30,
    required this.text12,
    required this.white,
    required this.white60,
    required this.white30,
    required this.white12,
    required this.brown,
    required this.brownMiddle,
    required this.brownDark,
    required this.gray,
    required this.gray2,
    required this.gray3,
    required this.bgLight,
    required this.bgDark,
    required this.delete,
  });

  const AppPalette.dark()
    : primary = const Color(0xffA0816C),
      primary60 = const Color.fromRGBO(160, 129, 108, 0.6),
      primary30 = const Color.fromRGBO(160, 129, 108, 0.3),
      primary12 = const Color.fromRGBO(160, 129, 108, 0.12),
      primaryDark = const Color(0xff654D3E),

      secondary = const Color(0xffC4BBB4),
      secondary60 = const Color.fromRGBO(196, 187, 180, 0.6),
      secondary30 = const Color.fromRGBO(196, 187, 180, 0.3),
      secondary12 = const Color.fromRGBO(196, 187, 180, 0.12),
      secondaryDark = const Color(0xffAFA6A0),

      peach = const Color(0xffFF843A),
      peach60 = const Color.fromRGBO(255, 132, 58, 0.6),
      peach30 = const Color.fromRGBO(255, 132, 58, 0.3),
      peach12 = const Color.fromRGBO(255, 132, 58, 0.12),
      cancelDark = const Color(0xffE95C1D),

      text = const Color(0xff3B3333),
      text60 = const Color.fromRGBO(59, 51, 51, 0.6),
      text30 = const Color.fromRGBO(59, 51, 51, 0.3),
      text12 = const Color.fromRGBO(59, 51, 51, 0.12),

      white = const Color(0xffFFFFFF),
      white60 = const Color.fromRGBO(255, 255, 255, 0.6),
      white30 = const Color.fromRGBO(255, 255, 255, 0.3),
      white12 = const Color.fromRGBO(255, 255, 255, 0.12),

      brown = const Color(0xff3F3630),
      brownMiddle = const Color(0xff312A25),
      brownDark = const Color(0xff272320),

      gray = const Color(0xffE7E6E6),
      gray2 = const Color(0xffE5E0D7),
      gray3 = const Color(0xffC5C2C2),

      bgLight = const Color(0xffF4F2EE),
      bgDark = const Color(0xff171412),
      delete = const Color(0xffFFAE00);
}
