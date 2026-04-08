import 'package:flutter/material.dart';
import '../../features/attendance/presentation/pages/attendance_history_screen.dart';
import '../../features/attendance/presentation/pages/attendance_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/upload_manager/presentation/pages/camera_preview_screen.dart';
import '../../features/upload_manager/presentation/pages/upload_manager_screen.dart';

enum AppRoutes {
  splash,
  home,
  attendance,
  attendanceHistory,
  uploadManager,
  cameraPreview,
}

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
      case AppRoutes.uploadManager:
        return const UploadManagerScreen();
      case AppRoutes.cameraPreview:
        return const CameraPreviewScreen();
    }
  }
}
