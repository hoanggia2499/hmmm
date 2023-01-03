/// App global config
class AppConfig {
  /// An instance must be set only once in startup
  static late final AppConfig instance;

  /// Base URL for authentication web APIs.
  final String authBaseUrl;

  /// Base URL for ASOP Mobile web APIs.
  final String baseUrl;

  /// Host of ASNET image URL.
  final String imageDomain;

  /// Base URL for ASOP images.
  final String asopImageHost;

  /// URL for privacy policy page.
  final String asopPrivacyLink;

  /// X-API-Key used to call authentication APIs.
  final String xApiKey;

  /// Id of this app to call authentication APIs.
  final int applicationId;

  const AppConfig({
    required this.authBaseUrl,
    required this.baseUrl,
    required this.imageDomain,
    required this.asopImageHost,
    required this.asopPrivacyLink,
    required this.xApiKey,
    required this.applicationId,
  });
}
