import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class AttendanceHistoryShimmerList extends StatelessWidget {
  const AttendanceHistoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: 44,
                  height: 44,
                  color: baseColor,
                  radius: 14,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBox(
                        width: double.infinity,
                        height: 16,
                        color: baseColor,
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        width: 180,
                        height: 12,
                        color: baseColor.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _ShimmerBox(
                            width: 92,
                            height: 28,
                            color: baseColor,
                            radius: 999,
                          ),
                          const SizedBox(width: 8),
                          _ShimmerBox(
                            width: 110,
                            height: 28,
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
