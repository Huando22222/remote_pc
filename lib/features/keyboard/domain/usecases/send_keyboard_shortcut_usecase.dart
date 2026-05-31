import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/keyboard/data/repositories/keyboard_repository_impl.dart';
import 'package:pc_remote/features/keyboard/domain/repositories/keyboard_repository.dart';

final sendKeyboardShortcutUseCaseProvider =
    Provider<SendKeyboardShortcutUseCase>((ref) {
  return SendKeyboardShortcutUseCase(ref.read(keyboardRepositoryProvider));
});

class SendKeyboardShortcutUseCase {
  SendKeyboardShortcutUseCase(this.repository);

  final KeyboardRepository repository;

  Future<void> call(List<String> keys) {
    return repository.sendShortcut(keys);
  }
}
