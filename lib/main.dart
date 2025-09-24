import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/Forms/login_user_page.dart';
import 'package:presence_app/controllers/session_binding.dart';
import 'package:presence_app/pages/exception_test_page.dart';
import 'package:presence_app/pages/practice_page.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/controllers/app_binding.dart';
import 'package:presence_app/controllers/scan_camera_binding.dart';
import 'package:presence_app/pages/access_restricted_page.dart';
import 'package:presence_app/pages/home_menu_page.dart';
import 'package:presence_app/pages/loading_page.dart';
import 'package:presence_app/pages/morning_list_page.dart';
import 'package:presence_app/pages/prfile_page_get.dart';
import 'package:presence_app/pages/profile_page_con.dart';
import 'package:presence_app/pages/session_page.dart';
import 'package:presence_app/pages/update_pass_page.dart';
import 'package:presence_app/controllers/profile_binding.dart';
import 'package:presence_app/qr_code_screen.dart';
import 'package:presence_app/scan_code_container.dart';

void main() {
  //Register auth service
  Get.put(AuthService());
  WidgetsFlutterBinding.ensureInitialized();
  const seed = Color(0xFF4A90E2);
  final lightScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );
  final darkScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
  TextTheme _buildTextTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true).textTheme
        : ThemeData.light(useMaterial3: true).textTheme;
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        textTheme: _buildTextTheme(Brightness.light),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        textTheme: _buildTextTheme(Brightness.dark),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      initialRoute: '/loading',

      getPages: [
        GetPage(
          name: '/loading',
          page: () => LoadingPage(),
          binding: ProfileBinding(),
        ),
        GetPage(name: '/login', page: () => LoginUserPage()),
        GetPage(
          name: '/home',
          page: () => HomeMenuPage(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/camera',
          page: () => ScanCodeContainer(),
          binding: ScanCameraBinding(),
        ),
        GetPage(name: '/update-password', page: () => UpdatePassPage()),
        GetPage(
          name: '/userProfile', //user-profile
          page: () => ProfilePageCon(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/designer',
          page: () => MorningListPage(
            title: 'morning',
            imageName: 'morning_cloud_sun.png',
          ),
          binding: AppBinding(),
        ),
        GetPage(
          name: '/qr',
          page: () => QrCodeScreen(session: "morning"),
        ),
        GetPage(
          name: '/morning-session',
          page: () => MorningListPage(
            title: 'morning',
            imageName: 'morning_cloud_sun.png',
          ),
          binding: AppBinding(),
        ),
        GetPage(
          name: '/evening-session',
          page: () => MorningListPage(
            title: 'evening',
            imageName: 'evening_cloud_sun.png',
          ),
          binding: AppBinding(),
        ),
        GetPage(
          name: '/profile',
          page: () => PrfilePageGet(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/session',
          page: () => SessionPage(),
          binding: SessionBinding(),
        ),
        GetPage(name: '/exception-test-page', page: () => ExceptionTestPage()),
        GetPage(name: '/access-restricted', page: () => AccessRestrictedPage()),
        GetPage(name: '/practice', page: () => PracticePage()),
      ],
    ),
  );
}
