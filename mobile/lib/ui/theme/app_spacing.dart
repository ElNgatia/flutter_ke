import 'package:flutter/material.dart';

/// Centralized spacing and padding values for the app.
/// Use these constants for consistent layout across all screens.
abstract final class AppSpacing {
  AppSpacing._();

  // Spacing scale (in logical pixels)
  static const double xxxs = 1;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  // Semantic spacing
  static const double listHorizontal = 12;
  static const double listVertical = 20;
  static const double screenPadding = base;
  static const double buttonHeight = 48;

  // EdgeInsets helpers
  static const EdgeInsets paddingAllBase = EdgeInsets.all(base);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingList = EdgeInsets.symmetric(
    horizontal: listHorizontal,
    vertical: listVertical,
  );
}
