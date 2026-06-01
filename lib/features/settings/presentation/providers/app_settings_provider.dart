import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:pc_remote/core/providers/core_providers.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.mouseSensitivity,
    required this.autoConnect,
    required this.lastConnectedIp,
  });

  final double mouseSensitivity;
  final bool autoConnect;
  final String? lastConnectedIp;

  AppSettingsState copyWith({
    double? mouseSensitivity,
    bool? autoConnect,
    String? lastConnectedIp,
  }) {
    return AppSettingsState(
      mouseSensitivity: mouseSensitivity ?? this.mouseSensitivity,
      autoConnect: autoConnect ?? this.autoConnect,
      lastConnectedIp: lastConnectedIp ?? this.lastConnectedIp,
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
