import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/reports_screen.dart';
import 'providers/theme_provider.dart';
import 'services/report_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

import 'screens/startup_screen.dart';
import 'screens/language_selection_screen.dart';
import 'services/tutorial_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('zh_TW', null);
  await Hive.initFlutter();
  await ReportStorageService.instance.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final ShowcaseView _showcaseView;

  @override
  void initState() {
    super.initState();
    _showcaseView = ShowcaseView.register(
      onFinish: TutorialService.instance.handleShowcaseFinish,
    );
  }

  @override
  void dispose() {
    _showcaseView.unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeNotifierProvider).value ?? ThemeMode.system;

    return MaterialApp(
      title: 'IngreSafe',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartupScreen(),
        '/select-language': (context) => const LanguageSelectionScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
