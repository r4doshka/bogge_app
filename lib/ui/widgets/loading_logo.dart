import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingLogo extends HookWidget {
  final bool withAnimate;
  const LoadingLogo({this.withAnimate = true, super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    final Animation<double> scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.1,
    ).animate(animationController);

    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        if (withAnimate)
          ScaleTransition(
            scale: scaleAnimation,
            child: SvgPicture.asset(
              'assets/icons/logo-icon.svg',
              width: 50.w,
              height: 50.w,
            ),
          )
        else
          Center(
            child: SvgPicture.asset(
              'assets/icons/logo-icon.svg',
              width: 50.w,
              height: 50.w,
            ),
          ),
      ],
    );
  }
}
