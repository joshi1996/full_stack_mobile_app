import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const subtle = <BoxShadow>[
    BoxShadow(blurRadius: 8, offset: Offset(0, 2), spreadRadius: 0),
  ];

  static const card = <BoxShadow>[
    BoxShadow(blurRadius: 12, offset: Offset(0, 4), spreadRadius: -2),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(blurRadius: 20, offset: Offset(0, 8), spreadRadius: -4),
  ];
}
