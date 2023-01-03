import 'dart:convert';

class PhotoUploadResponseModel {
  String fileName;
  String fileDownloadUri;

  PhotoUploadResponseModel({
    required this.fileName,
    required this.fileDownloadUri,
  });

  PhotoUploadResponseModel copyWith({
    String? fileName,
    String? fileDownloadUri,
  }) {
    return PhotoUploadResponseModel(
      fileName: fileName ?? this.fileName,
      fileDownloadUri: fileDownloadUri ?? this.fileDownloadUri,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileDownloadUri': fileDownloadUri,
    };
  }

  factory PhotoUploadResponseModel.fromMap(Map<String, dynamic> map) {
    return PhotoUploadResponseModel(
      fileName: map['fileName'] ?? '',
      fileDownloadUri: map['fileDownloadUri'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoUploadResponseModel.fromJson(String source) =>
      PhotoUploadResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UploadPhotoResponseModel(fileName: $fileName, fileDownloadUri: $fileDownloadUri)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhotoUploadResponseModel &&
        other.fileName == fileName &&
        other.fileDownloadUri == fileDownloadUri;
  }

  @override
  int get hashCode => fileName.hashCode ^ fileDownloadUri.hashCode;
}
