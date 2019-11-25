import 'package:flutter/material.dart';

class CustomMaterialColorsUtil {

static const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0x11000000),
    100: Color(0x33000000),
    200: Color(0x55000000),
    300: Color(0x77000000),
    400: Color(0x99000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xAA000000),
    700: Color(0xCC000000),
    800: Color(0xDD000000),
    900: Color(0xEE000000),
  },
);
static const int _blackPrimaryValue = 0xFF000000;

}