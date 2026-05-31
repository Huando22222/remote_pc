import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.mouseSensitivity,
  });

  final double mouseSensitivity;

  AppSettingsState copyWith({
    double? mouseSensitivity,
  }) {
    return AppSettingsState(
      mouseSensitivity: mouseSensitivity ?? this.mouseSensitivity,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static const defaultMouseSensitivity = 1.0;

  @override
  AppSettingsState build() {
    final storage = ref.read(localStorageProvider);
    return AppSettingsState(
      mouseSensitivity: storage.getDouble(PrefConstants.mouseSensitivity) ??
          defaultMouseSensitivity,
    );
  }

  Future<void> setMouseSensitivity(double value) async {
    final nextValue = value.clamp(0.4, 3.0).toDouble();
    state = state.copyWith(mouseSensitivity: nextValue);
    await ref
        .read(localStorageProvider)
        .setDouble(PrefConstants.mouseSensitivity, nextValue);
  }

  Future<void> resetMouseSensitivity() {
    return setMouseSensitivity(defaultMouseSensitivity);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);
