import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final UserSecureStorage instance = UserSecureStorage._internal();
  static const _keyPassword = 'password';
  static const _keyId = 'id';
  static const _keyMemberNum = 'memberNum';
  static const _keyUserNum = 'userNum';
  static const _accessToken = 'accessToken';
  static const _refreshToken = 'refreshToken';
  static const _keyStoreName = 'storeName';
  static const _keyStoreName2 = 'storeName2';
  static const _keyLogoMark = 'logoMark';
  static const _keyTel = 'keyTel';
  static const _keyTelCompany = 'keyTelCompany';
  static const _keyArea = 'area';
  static const _keyIsTermsAccepted = 'keyIsTermsAccepted';
  static const _keyVersionFirebase = 'version_Firebase';
  static const _keyVersionStore = 'version_Store';

  var _storage;

  UserSecureStorage._internal() {
    _storage = FlutterSecureStorage();
  }

  factory UserSecureStorage() {
    return instance;
  }

  Future setId(String username) async =>
      await _storage.write(key: _keyId, value: username);

  Future<String?> getId() async => await _storage.read(key: _keyId);

  // delete Id
  Future deleteId() async => await _storage.delete(key: _keyId);

  Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);

  Future<String?> getPassword() async => await _storage.read(key: _keyPassword);

  // delete password
  Future deletePassword() async => await _storage.delete(key: _keyPassword);

  // Member num & User num
  Future setMemberNum(String memberNum) async =>
      await _storage.write(key: _keyMemberNum, value: memberNum);

  Future<String?> getMemberNum() async =>
      await _storage.read(key: _keyMemberNum);

  Future setArea(String area) async =>
      await _storage.write(key: _keyArea, value: area);

  Future<String?> getArea() async => await _storage.read(key: _keyArea);

  Future removeMemberNum() async => await _storage.delete(key: _keyMemberNum);

  Future setUserNum(String userNum) async =>
      await _storage.write(key: _keyUserNum, value: userNum.padLeft(8, '0'));

  Future<String?> getUserNum() async => await _storage.read(key: _keyUserNum);

  Future removeUserNum() async => await _storage.delete(key: _keyUserNum);

  Future setTel(String tel) async =>
      await _storage.write(key: _keyTel, value: tel);

  Future<String?> getTel() async => await _storage.read(key: _keyTel);

  Future removeTel() async => await _storage.delete(key: _keyTel);

  Future setStoreName(String storeName) async =>
      await _storage.write(key: _keyStoreName, value: storeName);

  Future<String?> getStoreName() async =>
      await _storage.read(key: _keyStoreName);

  Future removeStoreName() async => await _storage.delete(key: _keyStoreName);

  Future setStoreName2(String storeName2) async =>
      await _storage.write(key: _keyStoreName2, value: storeName2);

  Future<String?> getStoreName2() async =>
      await _storage.read(key: _keyStoreName2);

  Future removeStoreName2() async => await _storage.delete(key: _keyStoreName2);

  Future setLogoMark(String logoMark) async =>
      await _storage.write(key: _keyLogoMark, value: logoMark);

  Future<String?> getLogoMark() async => await _storage.read(key: _keyLogoMark);

  Future removeLogoMark() async => await _storage.delete(key: _keyLogoMark);

  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessToken);

  Future setAccessToken(String accessToken) async =>
      await _storage.write(key: _accessToken, value: accessToken);

  Future deleteAccessToken() async => await _storage.delete(key: _accessToken);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshToken);

  Future setRefreshToken(String refreshToken) async =>
      await _storage.write(key: _refreshToken, value: refreshToken);

  Future deleteRefreshToken() async =>
      await _storage.delete(key: _refreshToken);

  Future setTelCompany(String tel) async =>
      await _storage.write(key: _keyTelCompany, value: tel);

  Future<String> getTelCompany() async =>
      await _storage.read(key: _keyTelCompany);

  Future removeTelCompany() async => await _storage.delete(key: _keyTelCompany);

  Future setIsTermsAccepted() async =>
      await _storage.write(key: _keyIsTermsAccepted, value: '1');

  Future<String?> getIsTermsAccepted() async =>
      await _storage.read(key: _keyIsTermsAccepted);

  Future setVersionStore(String version) async =>
      await _storage.write(key: _keyVersionStore, value: version);

  Future<String?> getVersionStore() async =>
      await _storage.read(key: _keyVersionStore);

  Future deleteVersionStore() async =>
      await _storage.delete(key: _keyVersionStore);

  Future setVersionFirebase(String version) async =>
      await _storage.write(key: _keyVersionFirebase, value: version);

  Future<String?> getVersionFirebase() async =>
      await _storage.read(key: _keyVersionFirebase);

  Future deleteVersionFirebase() async =>
      await _storage.delete(key: _keyVersionFirebase);
}
