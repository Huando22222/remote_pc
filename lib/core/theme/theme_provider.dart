import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import '../providers/core_providers.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final storage = ref.read(localStorageProvider);
    final theme = storage.getString(PrefConstants.themeMode);

    if (theme == ThemeMode.dark.name) return ThemeMode.dark;
    if (theme == ThemeMode.light.name) return ThemeMode.light;

    return ThemeMode.dark;
    // return ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode theme) async {
    final storage = ref.read(localStorageProvider);

    state = AsyncData(theme);

    await storage.setString(PrefConstants.themeMode, theme.name);
  }
}
