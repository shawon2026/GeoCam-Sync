import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/constants/api_urls.dart';
import '/core/di/service_locator.dart';
import '/core/localization/locale_manager.dart';
import '/core/presentation/widgets/global_network_listener.dart';
import '/core/routes/navigation.dart';
import '/core/theme/theme_manager.dart';
import '/core/utils/app_version.dart';
import '/core/utils/preferences_helper.dart';
import '/features/splash/presentation/pages/splash_page.dart';
import '/l10n/app_localizations.dart';
import 'core/presentation/widgets/app_starter_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize core services (preferences, API URLs, etc.)
    await initServices();

    // Initialize dependency injection (get_it service locator)
    // This must be called before runApp() to ensure all dependencies are ready
    await initDependencies();

    // Set Portrait Mode only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Log initialization error
    debugPrint('❌ App initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');

    runApp(MaterialApp(home: AppStarterError(error: e.toString())));
  }
}

/// Initialize core services
Future<void> initServices() async {
  const flavorType = String.fromEnvironment('flavorType', defaultValue: 'DEV');
  ApiUrlExtention.setUrl(flavorType == 'DEV' ? UrlLink.isDev : UrlLink.isLive);
  await PrefHelper.init();
  await LocaleManager.instance.loadSavedLocale();
  await AppVersion.getVersion();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleManager.instance.localeNotifier,
      builder: (context, locale, _) {
        return ScreenUtilInit(
          designSize: const Size(360, 800),
          minTextAdapt: true,
          builder: (ctx, child) {
            return MaterialApp(
              title: 'GeoCam Sync',
              navigatorKey: Navigation.key,
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: locale,
              theme: ThemeManager().themeData,
              builder: (context, child) {
                return GlobalNetworkListener(child: child ?? const SizedBox());
              },
              home: _getInitialPage(),
            );
          },
        );
      },
    );
  }

  /// Determine initial page
  Widget _getInitialPage() {
    return const SplashPage();
  }
}
