import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtil;

/// The size the interface is designed for.
///
/// The desktop windows are created at this size. Every dimension in the app
/// is expressed against it and scaled to the viewport the app actually gets.
const Size designSize = Size(360, 540);

/// Dimensions in design units, scaled to the current viewport.
///
/// The scaled value is rounded to whole pixels: the viewport rarely divides
/// evenly into the design size, and a padding or a hairline that lands on a
/// fraction is drawn blurred.
///
/// This shadows the `flutter_screenutil` extension of the same name on
/// purpose, so import that package with `show` where it is needed.
extension AdaptiveSize on num {
  double get w => ScreenUtil().setWidth(this).roundToDouble();

  double get h => ScreenUtil().setHeight(this).roundToDouble();

  double get sp => ScreenUtil().setSp(this).roundToDouble();
}
