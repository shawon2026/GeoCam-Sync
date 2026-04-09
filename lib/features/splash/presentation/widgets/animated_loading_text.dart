import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

class AnimatedLoadingText extends StatelessWidget {
  const AnimatedLoadingText({
    required this.controller,
    this.text = 'Loading',
    super.key,
  });

  final AnimationController controller;
  final String text;

  @override
  Widget build(BuildContext context) {
    final letters = text.split('');
    final step = 1 / letters.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(letters.length, (index) {
        final start = step * index;
        final end = (start + step).clamp(0.0, 1.0);

        final scaleAnimation = Tween<double>(begin: 0.85, end: 1.18).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        );

        final opacityAnimation = Tween<double>(begin: 0.45, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: Opacity(opacity: opacityAnimation.value, child: child),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.5),
            child: GlobalText.raw(
              letters[index],
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        );
      }),
    );
  }
}
