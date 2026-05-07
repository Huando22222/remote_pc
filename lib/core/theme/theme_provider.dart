// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ThemeNotifier extends AsyncNotifier<ThemeMode> {
//   @override
//   Future<ThemeMode> build() async {
//     final storage = ref.read(localStorageProvider);
//     final String theme = await storage.getTheme();

//     if (theme == 'dark') return ThemeMode.dark;
//     if (theme == 'light') return ThemeMode.light;
//     return ThemeMode.system;
//   }

//   Future<void> setTheme(ThemeMode theme) async {
//     final storage = ref.read(localStorageProvider);
//     state = AsyncData(theme);
//     await storage.setString(PrefConstants.themeMode, theme.name);
//   }
// }

// final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
//   ThemeNotifier.new,
// );
