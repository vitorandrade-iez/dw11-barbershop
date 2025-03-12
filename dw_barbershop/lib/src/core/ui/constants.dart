import 'package:flutter/material.dart';

sealed class ColorsConstants {
  static const brown = Color(0xFFB07B01);
  static const grey = Color(0xFF999999);
  static const lightGrey = Color(0xFFE6E2E9);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFEB1212);
  static const black = Color(0xFF000000);
}

sealed class FontConstants {
  static const fontFamily = 'Poppins';
}

sealed class ImageConstants {
  static const backgroundChair = 'assets/images/background_image_chair.jpg';
  static const imageLogo = 'assets/images/imgLogo.png';
  static const avatar = 'assets/images/avatar.png';
}

sealed class TextConstants {
  static const String appName = 'DW Barbershop';
}
