import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/asset_path.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Stack(children: [
      SvgPicture.asset(
        AssetsPath.backgroundSvg,
        fit: BoxFit.cover,
        width: screenSize.width,
        height: screenSize.height,
      ),
      SafeArea(child: child),
    ]);
  }
}
