import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  static timestampFormatMMMEd(int timestamp, context) {
    String languageCode = AppLocalizations.of(context)!.localeName;
    return DateFormat.MMMEd(languageCode).add_jm().format(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp,
          ),
        );
  }

  static dateFormatMMMEd(DateTime dateTime, context) {
    String languageCode = AppLocalizations.of(context)!.localeName;
    return DateFormat.MMMEd(languageCode).format(dateTime);
  }

  static dateFormatJm(int timestamp, context) {
    String languageCode = AppLocalizations.of(context)!.localeName;
    return DateFormat.jm(languageCode).format(
      DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      ),
    );
  }
}
