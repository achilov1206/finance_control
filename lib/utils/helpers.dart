import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static Map<String, dynamic> iconToCodeData(IconData icon) {
    return {
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'icon_font_package': icon.fontPackage,
      'icon_direction': icon.matchTextDirection,
    };
  }

  static IconData retrieveIconFromCodeData(Map<String, dynamic>? iconCodeData) {
    if (iconCodeData != null) {
      return IconData(
        iconCodeData['icon_code_point'],
        fontFamily: iconCodeData['icon_font_family'],
        fontPackage: iconCodeData['icon_font_package'],
        matchTextDirection: iconCodeData['icon_direction'],
      );
    }
    return Icons.circle;
  }

  static timestampFormatMMMEd(int timestamp) {
    return DateFormat.MMMEd().add_jm().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp,
          ),
        );
  }

  static dateFormatMMMEd(DateTime dateTime) {
    return DateFormat.MMMEd().format(dateTime);
  }
}
