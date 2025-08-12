import 'package:flutter/widgets.dart';

class AppContaints {
  static const double defaultPadding = 16.0;
  static const double largeSpacing = 32.0;
  static const double buttonHeight = 50.0;

  //Screen breakpoints
  static const double smallScreenBreakpoint = 600.0;
  static const double largeScreenBreakpoint = 1200.0;

  // Container sizes
  static const double headerImageSize = 120.0;
  static const double headerImageRadius = 12.0;
  static const double maxTextWidth = 400.0;

  static ScreenSizeInfo getScreenSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ScreenSizeInfo(width: screenSize.width, height: screenSize.height);
  }
}

class ScreenSizeInfo {
  final double width;
  final double height;

  const ScreenSizeInfo({required this.width, required this.height});

  bool get isSmallScreen => width < AppContaints.smallScreenBreakpoint;
  bool get isMediumScreen =>
      width >= AppContaints.smallScreenBreakpoint &&
      width < AppContaints.largeScreenBreakpoint;
  bool get isLargeScreen => width >= AppContaints.largeScreenBreakpoint;

 
}
