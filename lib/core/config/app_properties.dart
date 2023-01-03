class AppProperties {
  /// An instance must be set only once in startup
  static late final AppProperties instance;
  //アプリケーションサーバーのURL
  final String apSrvURL;
  //画像サーバーのURL
  final String imgSrvURL;
  //DEBUG MODE STATUS
  final bool isDebugMode;

  const AppProperties({
    required this.apSrvURL,
    required this.imgSrvURL,
    this.isDebugMode = false,
  });
}
