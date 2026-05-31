import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/keyboard/data/repositories/keyboard_repository_impl.dart';
import 'package:pc_remote/features/keyboard/domain/repositories/keyboard_repository.dart';

final sendKeyboardTextUseCaseProvider =
    Provider<SendKeyboardTextUseCase>((ref) {
  return SendKeyboardTextUseCase(ref.read(keyboardRepositoryProvider));
});

class SendKeyboardTextUseCase {
  SendKeyboardTextUseCase(this.repository);

  final KeyboardRepository repository;

  Future<void> call(String text) {
    return repository.sendText(text);
  }
}
