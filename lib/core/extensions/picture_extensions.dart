import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

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

  DecorationImage toContainerBG({double? size, Color? color}) {
    return DecorationImage(
      image: AssetImage("assets/images/pics/$this.jpg"),
      fit: BoxFit.cover,
    );
  }
}
