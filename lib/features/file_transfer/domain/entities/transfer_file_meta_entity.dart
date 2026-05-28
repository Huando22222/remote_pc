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
      'size': size,
      'extension': extension,
      'downloadUrl': downloadUrl,
    };
  }

  factory TransferFileMetaEntity.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransferFileMetaEntity(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      extension: json['extension'],
      downloadUrl: json['downloadUrl'],
    );
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
