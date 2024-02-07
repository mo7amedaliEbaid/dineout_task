import 'dart:io';

import 'package:dine_out_client/service/router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'service/constants.dart';
import 'service/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'en_US';
  await initializeDateFormatting(Intl.defaultLocale, null);

  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..displayDuration = const Duration(milliseconds: 4000);
  if (!supportedPlatform) {
    log.w('Unsupported platform: ${Platform.operatingSystem}');
  }

  runApp(const DineOutApp());
}

class DineOutApp extends StatelessWidget {
  const DineOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = _buildTheme();
    return MaterialApp.router(
      title: 'DineOut',
      scrollBehavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad
        },
        physics: const BouncingScrollPhysics(),
      ),
      theme: theme,
      routerConfig: router,
      builder: EasyLoading.init(),
    );
  }

  ThemeData _buildTheme() {
    final baseTheme = ThemeData.from(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF980046),
          secondary: const Color(0xFFDDDD00),
          onSecondary: const Color(0xFF000000),
        ));
    return baseTheme.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        headlineLarge: GoogleFonts.notoSans(
          textStyle: baseTheme.textTheme.headlineLarge,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.notoSans(
          textStyle: baseTheme.textTheme.headlineMedium,
        ),
        headlineSmall: GoogleFonts.notoSans(
          textStyle: baseTheme.textTheme.headlineSmall,
        ),
      ),
    );
  }
}
