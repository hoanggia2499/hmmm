class ServerException implements Exception {
  String code = '';
  String content = '';
  ServerException(this.code, this.content);
}

class CacheException implements Exception {}

class Timeout implements Exception {}
