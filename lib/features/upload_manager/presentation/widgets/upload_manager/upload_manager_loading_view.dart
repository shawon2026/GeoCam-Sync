import 'package:flutter/material.dart';

class UploadManagerLoadingView extends StatefulWidget {
  const UploadManagerLoadingView({super.key});

  @override
  State<UploadManagerLoadingView> createState() =>
      _UploadManagerLoadingViewState();
}

class _UploadManagerLoadingViewState extends State<UploadManagerLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFFE5EAF3);
    final highlightColor = const Color(0xFFF6F8FC);

    final skeleton = ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        Align(
          child: _box(
            width: 160,
            height: 34,
            radius: 999,
            color: baseColor,
          ),
        ),
        const SizedBox(height: 12),
        _box(
          width: double.infinity,
          height: 142,
          radius: 18,
          color: baseColor,
        ),
        const SizedBox(height: 18),
        _box(
          width: double.infinity,
          height: 44,
          radius: 12,
          color: baseColor,
        ),
        const SizedBox(height: 14),
        _box(
          width: double.infinity,
          height: 94,
          radius: 18,
          color: baseColor,
        ),
        const SizedBox(height: 12),
        _box(
          width: double.infinity,
          height: 94,
          radius: 18,
          color: baseColor,
        ),
        const SizedBox(height: 12),
        _box(
          width: double.infinity,
          height: 94,
          radius: 18,
          color: baseColor,
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _controller,
      child: skeleton,
      builder: (context, child) {
        final value = _controller.value;
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1.5 + (value * 3), -0.2),
              end: Alignment(-0.5 + (value * 3), 0.2),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child!,
        );
      },
    );
  }

  Widget _box({
    required double width,
    required double height,
    required double radius,
    required Color color,
  }) {
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
