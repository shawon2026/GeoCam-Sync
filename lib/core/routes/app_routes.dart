import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

enum AppRoutes { splash, home }

extension AppRoutesExtention on AppRoutes {
  Widget buildWidget<T extends Object>({T? arguments}) {
    switch (this) {
      case AppRoutes.splash:
        return const SplashPage();
      case AppRoutes.home:
        return const HomePage();
    }
  }
}
