import 'dart:io';

class SelectableFileEntity {
  final String id;
  final File file;
  final bool checked;

  const SelectableFileEntity({
    required this.id,
    required this.file,
    this.checked = true,
  });

  SelectableFileEntity copyWith({
    String? id,
    File? file,
    bool? checked,
  }) {
    return SelectableFileEntity(
      id: id ?? this.id,
      file: file ?? this.file,
      checked: checked ?? this.checked,
    );
  }
}
