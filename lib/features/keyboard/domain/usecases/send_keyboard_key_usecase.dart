import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_remote/features/keyboard/data/repositories/keyboard_repository_impl.dart';
import 'package:pc_remote/features/keyboard/domain/repositories/keyboard_repository.dart';

final sendKeyboardKeyUseCaseProvider = Provider<SendKeyboardKeyUseCase>((ref) {
  return SendKeyboardKeyUseCase(ref.read(keyboardRepositoryProvider));
});

class SendKeyboardKeyUseCase {
  SendKeyboardKeyUseCase(this.repository);

  final KeyboardRepository repository;

  Future<void> call(String key) {
    return repository.sendKey(key);
  }
}
