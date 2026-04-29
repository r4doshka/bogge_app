import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpace {
  AppSpace._();

  // raw values
  static const double s7 = 7;
  static const double s14 = 14;
  static const double s34 = 34;

  // height gaps
  static SizedBox get h14 => SizedBox(height: s14.h);

  // raw values
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s44 = 44;
  static const double s48 = 48;
  static const double s52 = 52;
  static const double s56 = 56;
  static const double s60 = 60;
  static const double s64 = 64;
  static const double s68 = 68;

  // height gaps
  static SizedBox get h2 => SizedBox(height: s2.h);
  static SizedBox get h4 => SizedBox(height: s4.h);
  static SizedBox get h8 => SizedBox(height: s8.h);
  static SizedBox get h12 => SizedBox(height: s12.h);
  static SizedBox get h16 => SizedBox(height: s16.h);
  static SizedBox get h20 => SizedBox(height: s20.h);
  static SizedBox get h24 => SizedBox(height: s24.h);
  static SizedBox get h32 => SizedBox(height: s32.h);
  static SizedBox get h36 => SizedBox(height: s36.h);
  static SizedBox get h40 => SizedBox(height: s40.h);
  static SizedBox get h44 => SizedBox(height: s44.h);
  static SizedBox get h68 => SizedBox(height: s68.h);

  // width gaps
  static SizedBox get w4 => SizedBox(width: s4.w);
  static SizedBox get w8 => SizedBox(width: s8.w);
  static SizedBox get w12 => SizedBox(width: s12.w);
  static SizedBox get w16 => SizedBox(width: s16.w);
  static SizedBox get w20 => SizedBox(width: s20.w);
  static SizedBox get w24 => SizedBox(width: s24.w);
  static SizedBox get w32 => SizedBox(width: s32.w);

  // padding all
  static EdgeInsetsDirectional get p4 => EdgeInsetsDirectional.all(s4.w);
  static EdgeInsetsDirectional get p8 => EdgeInsetsDirectional.all(s8.w);
  static EdgeInsetsDirectional get p12 => EdgeInsetsDirectional.all(s12.w);
  static EdgeInsetsDirectional get p16 => EdgeInsetsDirectional.all(s16.w);
  static EdgeInsetsDirectional get p20 => EdgeInsetsDirectional.all(s20.w);
  static EdgeInsetsDirectional get p24 => EdgeInsetsDirectional.all(s24.w);
  static EdgeInsetsDirectional get p32 => EdgeInsetsDirectional.all(s32.w);

  // padding horizontal
  static EdgeInsetsDirectional get ph4 =>
      EdgeInsetsDirectional.symmetric(horizontal: s4.w);
  static EdgeInsetsDirectional get ph8 =>
      EdgeInsetsDirectional.symmetric(horizontal: s8.w);
  static EdgeInsetsDirectional get ph12 =>
      EdgeInsetsDirectional.symmetric(horizontal: s12.w);
  static EdgeInsetsDirectional get ph16 =>
      EdgeInsetsDirectional.symmetric(horizontal: s16.w);
  static EdgeInsetsDirectional get ph20 =>
      EdgeInsetsDirectional.symmetric(horizontal: s20.w);
  static EdgeInsetsDirectional get ph24 =>
      EdgeInsetsDirectional.symmetric(horizontal: s24.w);
  static EdgeInsetsDirectional get ph32 =>
      EdgeInsetsDirectional.symmetric(horizontal: s32.w);

  // padding vertical
  static EdgeInsetsDirectional get pv4 =>
      EdgeInsetsDirectional.symmetric(vertical: s4.h);
  static EdgeInsetsDirectional get pv8 =>
      EdgeInsetsDirectional.symmetric(vertical: s8.h);
  static EdgeInsetsDirectional get pv12 =>
      EdgeInsetsDirectional.symmetric(vertical: s12.h);
  static EdgeInsetsDirectional get pv16 =>
      EdgeInsetsDirectional.symmetric(vertical: s16.h);
  static EdgeInsetsDirectional get pv20 =>
      EdgeInsetsDirectional.symmetric(vertical: s20.h);
  static EdgeInsetsDirectional get pv24 =>
      EdgeInsetsDirectional.symmetric(vertical: s24.h);
  static EdgeInsetsDirectional get pv32 =>
      EdgeInsetsDirectional.symmetric(vertical: s32.h);
}
