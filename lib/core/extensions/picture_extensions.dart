import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:r_expense/core/theme/app_color.dart';

extension PictureExtensions on String {
  Widget toSvgIcon({double? size = 17, Color? color}) {
    return SvgPicture.asset(
      "assets/images/icons/$this.svg",
      colorFilter: ColorFilter.mode(
        color ?? AppColor.onBackground,
        BlendMode.srcIn,
      ),
      width: size,
      height: size,
    );
  }
}
