import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/version_utils/new_version.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../connection_util.dart';

class VersionUtils {
  static VersionUtils? _instance;
  final FirebaseRemoteConfig _remoteConfig;

  // Avoid self instance
  VersionUtils({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  static VersionUtils get instance {
    _instance ??= VersionUtils(
      remoteConfig: FirebaseRemoteConfig.instance,
    );
    return _instance!;
  }

  Future<FirebaseRemoteConfig?> initFirebaseRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: Duration.zero));
      await _remoteConfig.fetchAndActivate();
      return _remoteConfig;
    } on PlatformException catch (e) {
      Logging.log.error(
          'Unable to fetch remote config. Cached or default values will be '
          'used',
          e);
    } catch (e) {
      Logging.log.error(e);
      return null;
    }
    return null;
  }

  Future<int> checkVersion(
      {required String remoteConfigVersion, String storeVersion = ''}) async {
    Logging.log.info("Remote config version: " + remoteConfigVersion);
    //Logging.log.info("Store version: " + storeVersion);

    var appVersionFromLocal = await this.getAppVersionFromLocal();
    Logging.log.info("Local version: $appVersionFromLocal");
    return versionCompare(remoteConfigVersion, appVersionFromLocal);
  }

  /// Get Firebase Version from Firebase Remote Config
  Future<String> getFirebaseVersion() async {
    var remoteConfig = await initFirebaseRemoteConfig();
    var appVersion = '0.0.0';
    if (remoteConfig != null) {
      if (Platform.isAndroid) {
        appVersion = remoteConfig.getString("android_version");
      } else if (Platform.isIOS) {
        appVersion = remoteConfig.getString("ios_version");
      }
    }
    return appVersion;
  }

  // Get app's latest version from Store (AppStore or Play Store)
  Future<String> getLatestVersionFromStore() async {
    var appVersion = '0.0.0';
    try {
      var newVersion = NewVersion(
          androidId: ANDROID_ID,
          iOSId: IOS_BUNDLE_ID,
          iOSAppStoreCountry: IOS_APPSTORE_COUNTRY);

      final versionStatus = await newVersion.getVersionStatus();
      if (versionStatus != null) {
        appVersion = versionStatus.storeVersion;
      }
      return appVersion;
    } on PlatformException catch (e) {
      Logging.log.error(e);
    } catch (e) {
      Logging.log.error("Unable to get latest version", e);
    }
    return appVersion;
  }

  Future<String> getAppVersionFromLocal() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> launchAppStore() async {
    var newVersion = NewVersion(
        androidId: ANDROID_ID,
        iOSId: IOS_BUNDLE_ID,
        iOSAppStoreCountry: IOS_APPSTORE_COUNTRY);

    var appStoreLink;
    final versionStatus = await newVersion.getVersionStatus();
    if (versionStatus != null) {
      appStoreLink = versionStatus.appStoreLink + '&hl=ja&gl=jp';
    }
    await newVersion.launchAppStore(appStoreLink);
  }

  Future<String> getAppName() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      Logging.log.info('Cant connect internet');
      return false;
    }
    return false;
  }

  Future<void> clearBeforeCheckUpdate() async {
    if (await InternetConnection.instance.isHasConnection()) {
      await UserSecureStorage.instance.deleteVersionFirebase();
      await UserSecureStorage.instance.deleteVersionStore();

      // Get the firebase latest version
      var remoteConfigVersion =
          await VersionUtils.instance.getFirebaseVersion();

      if (remoteConfigVersion.trim().isEmpty) {
        remoteConfigVersion = '0.0.0';
      }
      Logging.log.info('Remote config version: $remoteConfigVersion');

      if (remoteConfigVersion.trim() != '0.0.0') {
        await UserSecureStorage.instance
            .setVersionFirebase(remoteConfigVersion.trim());
      }
    }
  }

  Future<void> showForceUpdateDialog(
      BuildContext context, String version, String appName) {
    var content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          label: "NEW_VERSION_NOTIFICATION_TITLE".tr(),
          textStyle: MKStyle.t12B.copyWith(color: ResourceColors.color_333333),
        ),
        SizedBox(
          height: Dimens.getHeight(10.0),
        ),
        TextWidget(
          label: "NEW_VERSION_NOTIFICATION_CONTENT"
              .tr(namedArgs: {"appName": appName, "newVersion": version}),
          textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
        )
      ],
    );
    return CommonDialog.displayConfirmOneButtonDialog(
        context, content, "NEW_VERSION_UPDATE".tr(), "NEW_VERSION_UPDATE".tr(),
        cancelEvent: () async {
      await this.launchAppStore();
    }, isAutoDismiss: false);
  }

  Future<void> showNoInternetDialog(BuildContext context) {
    var content = TextWidget(
      label: "NO_INTERNET".tr(),
      textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
    );
    return CommonDialog.displayConfirmOneButtonDialog(
        context, content, "OK", "",
        okEvent: () async => {Navigator.of(context).pop()},
        isAutoDismiss: false);
  }

  Future<bool> showOptionalUpdateDialog(
      BuildContext context, String version, String appName) async {
    var isInit = false;
    var content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          label: "NEW_VERSION_NOTIFICATION_TITLE".tr(),
          textStyle: MKStyle.t12B.copyWith(color: ResourceColors.color_333333),
        ),
        SizedBox(
          height: Dimens.getHeight(10.0),
        ),
        TextWidget(
          label: "NEW_VERSION_NOTIFICATION_CONTENT"
              .tr(namedArgs: {"appName": appName, "newVersion": version}),
          textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_333333),
        )
      ],
    );
    await CommonDialog.displayConfirmDialog(context, content,
        "NEW_VERSION_UPDATE".tr(), "NEW_VERSION_NEXT_TIME".tr(),
        okEvent: () async => {await this.launchAppStore()},
        cancelEvent: () {
          isInit = true;
        },
        isAutoDismiss: false);
    return isInit;
  }

  // Compare version
  static int versionCompare(String newVersion, String currentVersion) {
    // This will split both the versions by '.'
    var arr1 = newVersion.split(".");
    var arr2 = currentVersion.split(".");
    // converts to integer from string
    var arr1Int = arr1.map(int.parse).toList();
    var arr2Int = arr2.map(int.parse).toList();
    // compares which list is bigger and FILLS
    // smaller list with zero (for unequal delimiters)
    // var n = arr1.length;
    // var m = arr2.length;
    // if (n > m) {
    //   for (var i = n; i < m + 1; i++) {
    //     arr2Int.add(0);
    //   }
    // } else if (m > n) {
    //   for (var i = m; i < n + 1; i++) {
    //     arr1Int.add(0);
    //   }
    // }
    // returns 1, 2 or 3 if version 1 is bigger
    // and -1 if version 2 is bigger and 0 if equal
    for (var i = 0; i < arr1Int.length; i++) {
      if (arr1Int[i] > arr2Int[i]) {
        //return 1;
        if (i == 0) {
          // Force update
          return 1;
        } else if (i == 1) {
          // Optional update
          return 2;
        } else {
          return 3;
        }
      } else if (arr2Int[i] > arr1Int[i]) {
        return -1;
      }
    }
    return 0;
  }

  // Setting ID APP
  static const String ANDROID_ID = 'jp.mlkl.mirukuru';
  static const String IOS_BUNDLE_ID = 'jp.mlkl.mirukuru';
  static const String ID_APPSTORE_MIRUKURU = '202205';
  static const String IOS_APPSTORE_COUNTRY = 'jp';

  // Setting FirebaseRemoteConfig
  static const String API_KEY = "AIzaSyA3TR8MKFqeHgtLMyzsEIFHAAS1meqXlVA";
  static const String APP_ID = "1:325093841383:android:5de927d334e497c5148542";
  static const String PROJECT_ID = "mirukuru-25e02";
  static const String MESSAGING_SENDER_ID = "325093841383";
}

enum CheckUpdateType {
  optional(checkId: 2),
  force(checkId: 1);

  final int checkId;

  const CheckUpdateType({required this.checkId});
}
