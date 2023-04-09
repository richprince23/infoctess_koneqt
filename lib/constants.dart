//Buttons

import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

// class C {
Size btnLarge(BuildContext context) {
  return Size((MediaQuery.of(context).size.width), 50.h);
}

Size btnSmall(BuildContext context) {
  return Size(200, (MediaQuery.of(context).size.height) * 0.06);
}

double btnRadius(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.02;
}

double btnRadiusSmall(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

//font sizes
f10(BuildContext context) => MediaQuery.of(context).size.height * 0.010 + 2;
f12(BuildContext context) => MediaQuery.of(context).size.height * 0.012 + 2;
f14(BuildContext context) => MediaQuery.of(context).size.height * 0.014 + 2;
f16(BuildContext context) => MediaQuery.of(context).size.height * 0.016 + 2;
f18(BuildContext context) => MediaQuery.of(context).size.height * 0.018 + 2;
f20(BuildContext context) => MediaQuery.of(context).size.height * 0.020 + 2;
f22(BuildContext context) => MediaQuery.of(context).size.height * 0.022 + 2;
f24(BuildContext context) => MediaQuery.of(context).size.height * 0.024 + 2;
f26(BuildContext context) => MediaQuery.of(context).size.height * 0.026 + 2;
f28(BuildContext context) => MediaQuery.of(context).size.height * 0.028 + 2;
f30(BuildContext context) => MediaQuery.of(context).size.height * 0.030 + 2;
f32(BuildContext context) => MediaQuery.of(context).size.height * 0.032 + 2;
f34(BuildContext context) => MediaQuery.of(context).size.height * 0.034 + 2;
f36(BuildContext context) => MediaQuery.of(context).size.height * 0.036 + 2;
f38(BuildContext context) => MediaQuery.of(context).size.height * 0.038 + 2;
f40(BuildContext context) => MediaQuery.of(context).size.height * 0.040 + 2;
f42(BuildContext context) => MediaQuery.of(context).size.height * 0.042 + 2;
f44(BuildContext context) => MediaQuery.of(context).size.height * 0.044 + 2;

// height spacers
double sh1(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}

double sh2(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.02;
}

double sh4(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.04;
}

double sh6(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.06;
}

double sh8(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.08;
}

double sh10(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.10;
}

double sh12(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.12;
}

double sh14(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.14;
}

double sh16(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.16;
}

double sh18(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.18;
}

double sh20(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.20;
}

double sh22(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.22;
}

double sh24(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.24;
}

double sh26(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.26;
}

double sh28(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.28;
}

double sh30(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.30;
}

// width spacers
double sw1(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.01;
}

double sw2(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.02;
}

double sw4(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.04;
}

double sw6(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.06;
}

double sw8(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.08;
}

double sw10(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.10;
}

double sw12(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.12;
}

double sw14(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.14;
}

double sw16(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.16;
}

double sw18(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.18;
}

double sw20(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.20;
}

double sw22(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.22;
}

double sw24(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.24;
}

double sw26(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.26;
}

double sw28(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.28;
}

double sw30(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.30;
}

// colors
Color cPri = const Color.fromRGBO(74, 19, 193, 1);
Color cSec = const Color.fromRGBO(246, 7, 151, 1);
// Color cTert = const Color.fromRGBO(246, 7, 151, 1);

