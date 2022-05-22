import 'package:flutter/material.dart';

class Helpers {
  static Map<String, dynamic> iconToCodeData(IconData icon) {
    return {
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'icon_font_package': icon.fontPackage,
      'icon_direction': icon.matchTextDirection,
    };
  }

  static IconData? retrieveIconFromCodeData(
      Map<String, dynamic>? iconCodeData) {
    if (iconCodeData != null) {
      return IconData(
        iconCodeData['icon_code_point'],
        fontFamily: iconCodeData['icon_font_family'],
        fontPackage: iconCodeData['icon_font_package'],
        matchTextDirection: iconCodeData['icon_direction'],
      );
    }
    return null;
  }
}
