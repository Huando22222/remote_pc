import 'dart:convert';

class TransferFileMetaEntity {
  final String id;
  final String name;
  final int size;
  final String extension;
  final String downloadUrl;

  const TransferFileMetaEntity({
    required this.id,
    required this.name,
    required this.size,
    required this.extension,
    required this.downloadUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameBase64': base64Encode(utf8.encode(name)),
      'size': size,
      'extension': extension,
      'downloadUrl': downloadUrl,
    };
  }

  factory TransferFileMetaEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    final decodedName = _readName(json);
    return TransferFileMetaEntity(
      id: json['id'],
      name: decodedName,
      size: json['size'],
      extension: json['extension'] ?? _extensionOf(decodedName),
      downloadUrl: json['downloadUrl'],
    );
  }

  static String _readName(Map<String, dynamic> json) {
    final nameBase64 = json['nameBase64'];
    if (nameBase64 is String && nameBase64.isNotEmpty) {
      try {
        return utf8.decode(base64Decode(nameBase64));
      } catch (_) {
        // Fall back to the legacy plain-text name below.
      }
    }

    return json['name'] ?? 'file.bin';
  }

  static String _extensionOf(String name) {
    final index = name.lastIndexOf('.');
    if (index == -1) return '';
    return name.substring(index);
  }
}
// {
//   "files": [
//     {
//       "id": "abc",
//       "name": "report.pdf",
//       "size": 2400000,
//       "mimeType": "application/pdf",
//       "extension": ".pdf",
//       "downloadUrl": "http://192.168.1.5:2223/download/abc"
//     }
//   ]
// }
