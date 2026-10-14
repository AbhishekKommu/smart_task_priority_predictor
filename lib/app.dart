import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'widgets/gradient_background.dart';

class SmartTaskApp extends StatefulWidget {
  const SmartTaskApp({super.key});

  static SmartTaskAppState of(BuildContext context) =>
      context.findAncestorStateOfType<SmartTaskAppState>()!;

  @override
  State<SmartTaskApp> createState() => SmartTaskAppState();
}

class SmartTaskAppState extends State<SmartTaskApp> {
  ThemeMode mode = ThemeMode.light;

  bool get isDark => mode == ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    StorageService().loadDark().then((v) {
      if (mounted) setState(() => mode = v ? ThemeMode.dark : ThemeMode.light);
    });
  }

  void setDark(bool v) =>
      setState(() => mode = v ? ThemeMode.dark : ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Task Priority Predictor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      builder: (context, child) => GradientBackground(child: child!),
      home: const HomeScreen(),
    );
  }
}
