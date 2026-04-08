import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';

enum AppRoutes { home }

extension AppRoutesExtention on AppRoutes {
  Widget buildWidget<T extends Object>({T? arguments}) {
    switch (this) {
      case AppRoutes.home:
        return const HomePage();
    }
  }
}

