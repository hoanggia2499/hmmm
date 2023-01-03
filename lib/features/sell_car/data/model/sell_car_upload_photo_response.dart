// import 'dart:convert';
//
// class SellCarUploadPhotoResponseModel {
//   String fileName;
//   String fileDownloadUri;
//
//   SellCarUploadPhotoResponseModel({
//     required this.fileName,
//     required this.fileDownloadUri,
//   });
//
//   SellCarUploadPhotoResponseModel copyWith({
//     String? fileName,
//     String? fileDownloadUri,
//   }) {
//     return SellCarUploadPhotoResponseModel(
//       fileName: fileName ?? this.fileName,
//       fileDownloadUri: fileDownloadUri ?? this.fileDownloadUri,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'fileName': fileName,
//       'fileDownloadUri': fileDownloadUri,
//     };
//   }
//
//   factory SellCarUploadPhotoResponseModel.fromMap(Map<String, dynamic> map) {
//     return SellCarUploadPhotoResponseModel(
//       fileName: map['fileName'] ?? '',
//       fileDownloadUri: map['fileDownloadUri'] ?? '',
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory SellCarUploadPhotoResponseModel.fromJson(String source) =>
//       SellCarUploadPhotoResponseModel.fromMap(json.decode(source));
//
//   @override
//   String toString() =>
//       'UploadPhotoResponseModel(fileName: $fileName, fileDownloadUri: $fileDownloadUri)';
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is SellCarUploadPhotoResponseModel &&
//         other.fileName == fileName &&
//         other.fileDownloadUri == fileDownloadUri;
//   }
//
//   @override
//   int get hashCode => fileName.hashCode ^ fileDownloadUri.hashCode;
// }
