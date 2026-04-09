import 'dart:developer' as darttools show log;

import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

extension Context on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension Log on Object {
  void log() => darttools.log(toString());
}
