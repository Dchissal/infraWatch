import 'package:flutter/material.dart';
import 'package:infrawatch/theme.dart';

// Utility class for gradients
class AppGradients {
  static LinearGradient primaryGradient(Brightness brightness) => brightness == Brightness.light
      ? const LinearGradient(
          colors: [LightModeColors.primaryGradientStart, LightModeColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [DarkModeColors.primaryGradientStart, DarkModeColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  static LinearGradient successGradient(Brightness brightness) => brightness == Brightness.light
      ? const LinearGradient(
          colors: [LightModeColors.successGradientStart, LightModeColors.successGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [DarkModeColors.successGradientStart, DarkModeColors.successGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  static LinearGradient warningGradient(Brightness brightness) => brightness == Brightness.light
      ? const LinearGradient(
          colors: [LightModeColors.warningGradientStart, LightModeColors.warningGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [DarkModeColors.warningGradientStart, DarkModeColors.warningGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  static LinearGradient errorGradient(Brightness brightness) => brightness == Brightness.light
      ? const LinearGradient(
          colors: [LightModeColors.errorGradientStart, LightModeColors.errorGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [DarkModeColors.errorGradientStart, DarkModeColors.errorGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  static LinearGradient secondaryGradient(Brightness brightness) => brightness == Brightness.light
      ? const LinearGradient(
          colors: [LightModeColors.secondaryGradientStart, LightModeColors.secondaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [DarkModeColors.secondaryGradientStart, DarkModeColors.secondaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
}