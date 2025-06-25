import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicTaskLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isDark;

  const TicTaskLogo({
    super.key,
    this.width,
    this.height,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      isDark ? 'assets/images/logo_dark.svg' : 'assets/images/logo_light.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class TicTaskIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isDark;

  const TicTaskIcon({
    super.key,
    this.width,
    this.height,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      isDark ? 'assets/images/icon_dark.svg' : 'assets/images/icon_light.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
