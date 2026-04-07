import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  static const String _basePath = 'assets/images/icons';

  static Widget plus({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/plus.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget safe({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/safe.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget warning({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/warning.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget danger({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/danger.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrowRight({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/arrow-right.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrowLeft({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/arrow-left.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrowUp({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/arrow-up.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrowDown({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/arrow-down.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget info({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/info.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget photoLibs({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/photo_libs.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget camera({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/camera.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget refs({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/refs.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrow2Left({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/_-left.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrow2Right({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/_-right.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrow2Up({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/_-up.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget arrow2Down({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/_-down.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget shield({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/shield.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget toxic({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/toxic.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget eyeOff({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/eye-off.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget scanEye({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/scan-eye.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget globe({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/globe.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget trash({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/trash.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget cross({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/cross.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  static Widget reanalyze({double? size, double? height, Color? color}) {
    return SvgPicture.asset(
      '$_basePath/edit.svg',
      width: size,
      height: height ?? size,
      fit: BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
