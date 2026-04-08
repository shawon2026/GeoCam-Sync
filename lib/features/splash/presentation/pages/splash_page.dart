import 'package:flutter/material.dart';
import '/core/routes/app_routes.dart';
import '/core/routes/navigation.dart';
import '/core/utils/styles/k_assets.dart';
import '/features/splash/presentation/widgets/animated_loading_text.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    _loadingController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1800),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            Navigation.pushAndRemoveUntil(context, appRoutes: AppRoutes.home);
          }
        });

    _loadingController.forward();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                KAssetName.logoJpg.imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              AnimatedLoadingText(controller: _loadingController),
            ],
          ),
        ),
      ),
    );
  }
}
