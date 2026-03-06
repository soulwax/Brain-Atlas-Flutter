import 'package:flutter/material.dart';

import '../features/expedition/presentation/brain_expedition_screen.dart';

class BrainExpeditionApp extends StatelessWidget {
  const BrainExpeditionApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseBackground = Color(0xFF07131B);
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF4AD7B1),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF4AD7B1),
          secondary: const Color(0xFFF3C96C),
          surface: const Color(0xFF10222C),
          surfaceContainerHighest: const Color(0xFF17313C),
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neural Cartographer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: baseBackground,
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF10222C),
          selectedColor: const Color(0xFF17313C),
          disabledColor: const Color(0xFF0C1920),
          labelStyle: const TextStyle(
            color: Color(0xFFE7F1F5),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF224451)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: const Color(0xFF051016),
            backgroundColor: const Color(0xFF4AD7B1),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE7F1F5),
            side: const BorderSide(color: Color(0xFF244552)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F8FA),
            height: 1.05,
          ),
          headlineSmall: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F8FA),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F8FA),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F8FA),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFFD5E3E8),
            height: 1.45,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFFB8CBD4),
            height: 1.4,
          ),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      home: const BrainExpeditionScreen(),
    );
  }
}
