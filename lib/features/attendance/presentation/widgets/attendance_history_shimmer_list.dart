import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/theme/app_colors.dart';

class AttendanceHistoryShimmerList extends StatelessWidget {
  const AttendanceHistoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemBuilder: (context, index) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final baseColor = Color.lerp(
          AppColors.lightGrey.color,
          AppColors.white.color,
          _controller.value,
        )!;

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.white.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: 44.w,
                  height: 44.h,
                  color: baseColor,
                  radius: 14,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(
                        width: double.infinity,
                        height: 16.h,
                        color: baseColor,
                      ),
                      SizedBox(height: 8.h),
                      _ShimmerBox(
                        width: 180.w,
                        height: 12.h,
                        color: baseColor.withValues(alpha: 0.9),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _ShimmerBox(
                            width: 92.w,
                            height: 28.h,
                            color: baseColor,
                            radius: 999,
                          ),
                          SizedBox(width: 8.w),
                          _ShimmerBox(
                            width: 110.w,
                            height: 28.h,
                            color: baseColor.withValues(alpha: 0.9),
                            radius: 999,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 8,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
