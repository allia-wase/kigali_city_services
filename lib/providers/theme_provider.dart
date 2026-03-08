import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { system, light, dark }

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) => ThemeModeNotifier(),
);

final flutterThemeModeProvider = Provider<ThemeMode>((ref) {
  final appMode = ref.watch(themeModeProvider);
  switch (appMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system);

  void setTheme(AppThemeMode mode) {
    state = mode;
  }
}
