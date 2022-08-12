import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension MyLocalization on BuildContext {
  AppLocalizations get myloc {
    return AppLocalizations.of(this)!;
  }
}
