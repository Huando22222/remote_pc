import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.mouseSensitivity,
    required this.scrollSensitivity,
    required this.autoConnect,
    required this.lastConnectedIp,
  });

  final double mouseSensitivity;
  final double scrollSensitivity;
  final bool autoConnect;
  final String? lastConnectedIp;

  AppSettingsState copyWith({
    double? mouseSensitivity,
    double? scrollSensitivity,
    bool? autoConnect,
    String? lastConnectedIp,
  }) {
    return AppSettingsState(
      mouseSensitivity: mouseSensitivity ?? this.mouseSensitivity,
      scrollSensitivity: scrollSensitivity ?? this.scrollSensitivity,
      autoConnect: autoConnect ?? this.autoConnect,
      lastConnectedIp: lastConnectedIp ?? this.lastConnectedIp,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static const defaultMouseSensitivity = 1.0;
  static const defaultScrollSensitivity = 0.7;

  @override
  AppSettingsState build() {
    final storage = ref.read(localStorageProvider);
    return AppSettingsState(
      mouseSensitivity: storage.getDouble(PrefConstants.mouseSensitivity) ??
          defaultMouseSensitivity,
      scrollSensitivity: storage.getDouble(PrefConstants.scrollSensitivity) ??
          defaultScrollSensitivity,
      autoConnect: storage.getBool(PrefConstants.autoConnect) ?? true,
      lastConnectedIp: storage.getString(PrefConstants.lastConnectedIp),
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

  Future<void> setScrollSensitivity(double value) async {
    final nextValue = value.clamp(0.2, 2.0).toDouble();
    state = state.copyWith(scrollSensitivity: nextValue);
    await ref
        .read(localStorageProvider)
        .setDouble(PrefConstants.scrollSensitivity, nextValue);
  }

  Future<void> resetScrollSensitivity() {
    return setScrollSensitivity(defaultScrollSensitivity);
  }

  Future<void> setAutoConnect(bool value) async {
    state = state.copyWith(autoConnect: value);
    await ref
        .read(localStorageProvider)
        .setBool(PrefConstants.autoConnect, value);
  }

  Future<void> setLastConnectedIp(String ip) async {
    state = state.copyWith(lastConnectedIp: ip);
    await ref
        .read(localStorageProvider)
        .setString(PrefConstants.lastConnectedIp, ip);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);
