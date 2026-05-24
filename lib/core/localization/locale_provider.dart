import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';
import 'app_strings.dart';
import 'translations/en.dart';
import 'translations/vi.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('vi');

  Future<void> loadSavedLocale() async {
    final storage = ref.read(localStorageProvider);
    final code = await storage.getLocale();
    state = Locale(code);
  }

  Future<void> changeLocale(Locale locale) async {
    state = locale;
    final storage = ref.read(localStorageProvider);
    await storage.setString(PrefConstants.appLocale, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    final newLocale =
        state.languageCode == 'vi' ? const Locale('en') : const Locale('vi');
    await changeLocale(newLocale);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return switch (locale.languageCode) {
    'en' => EnStrings(),
    _ => ViStrings(),
  };
});
