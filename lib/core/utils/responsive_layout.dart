import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double maxContentWidth = 1400;
}

/// Helper class for responsive layouts
class ResponsiveLayout {
  /// Check if current platform is web
  static bool isWeb() => kIsWeb;

  /// Get screen width from context
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Check if screen is mobile size
  static bool isMobile(BuildContext context) {
    return getWidth(context) < ResponsiveBreakpoints.mobile;
  }

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = getWidth(context);
    return width >= ResponsiveBreakpoints.mobile &&
        width < ResponsiveBreakpoints.desktop;
  }

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return getWidth(context) >= ResponsiveBreakpoints.desktop;
  }

  /// Get column count for grid based on screen size
  static int getColumnCount(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Get responsive padding based on screen size
  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return 40.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get responsive card aspect ratio
  static double getCardAspectRatio(
    BuildContext context, {
    double mobile = 1.5,
    double tablet = 1.4,
    double desktop = 1.3,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Wrap content with max-width constraint for web
  static Widget constrainWidth({required Widget child, double? maxWidth}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveBreakpoints.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
