import 'new_question_model.dart';

class UploadPhotoResponseModel extends NewQuestionModel {
  UploadPhotoResponseModel({
    String? fileName,
    String? fileDownloadUri,
  }) : super(
          fileName: fileName,
          fileDownloadUri: fileDownloadUri,
        );

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadPhotoResponseModel(
      fileName: json['fileName'],
      fileDownloadUri: json['fileDownloadUri'],
    );
  }

  factory UploadPhotoResponseModel.convertForm(NewQuestionModel request) {
    return UploadPhotoResponseModel(
      fileName: request.fileName,
      fileDownloadUri: request.fileDownloadUri,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileDownloadUri': fileDownloadUri,
    };
  }
}
