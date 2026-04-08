import 'package:flutter/material.dart';
import '../../features/attendance/presentation/pages/attendance_history_screen.dart';
import '../../features/attendance/presentation/pages/attendance_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

enum AppRoutes { splash, home, attendance, attendanceHistory }

extension AppRoutesExtention on AppRoutes {
  Widget buildWidget<T extends Object>({T? arguments}) {
    switch (this) {
      case AppRoutes.splash:
        return const SplashPage();
      case AppRoutes.home:
        return const HomePage();
      case AppRoutes.attendance:
        return const AttendanceScreen();
      case AppRoutes.attendanceHistory:
        return const AttendanceHistoryScreen();
    }
  }
}
