import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/core/storage/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final localStorageProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return LocalStorageService(prefs);
});
