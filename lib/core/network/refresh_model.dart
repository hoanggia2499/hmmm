class RefreshModel {
  final String accessToken;
  final String refreshToken;

  RefreshModel({this.accessToken = '', this.refreshToken = ''});

  factory RefreshModel.fromJson(Map<String, dynamic> json) {
    return RefreshModel(
        accessToken: json['accessToken'] ?? '',
        refreshToken: json['refreshToken'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken
    };
  }
}
