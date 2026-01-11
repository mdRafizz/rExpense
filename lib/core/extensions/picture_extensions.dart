import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:r_expense/core/theme/app_color.dart';

extension PictureExtensions on String {
  Widget toSvgIcon({double? size = 17, Color? color}) {
    return SvgPicture.asset(
      "assets/images/icons/$this.svg",
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      width: size,
      height: size,
    );
  }
}
