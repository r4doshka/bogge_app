import 'package:flutter/material.dart';

class AppBoxShadows {
  static const buttonBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x5476410B),
      offset: Offset(0, 9),
      blurRadius: 21.2,
      spreadRadius: -6,
    ),
  ];
  static const buttonSmallBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x5476410B),
      offset: Offset(0, 4),
      blurRadius: 20.2,
      spreadRadius: -6,
    ),
  ];
  static const defaultBoxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x4576410B),
      offset: Offset(0, 6),
      blurRadius: 10.2,
      spreadRadius: -6,
    ),
  ];
}
