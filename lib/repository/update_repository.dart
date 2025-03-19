import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remote_config_demo/utils/api_constants.dart';
import 'package:flutter_remote_config_demo/utils/app_costants.dart';
import 'package:flutter_remote_config_demo/utils/app_dependency_injector.dart';
import 'package:flutter_remote_config_demo/widgets/mandatory_update_dialog.dart';
import 'package:flutter_remote_config_demo/widgets/optional_update_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRepository {
  final packageInfo = getIt<PackageInfo>();
  final remoteConfig = getIt<FirebaseRemoteConfig>();

  Future<void> checkForUpdate(BuildContext context) async {
    // fetch the latest data
    remoteConfig.fetchAndActivate();

    log("This is from the remote config...");
    String latestAppVersion =
        remoteConfig.getString(ApiConstant.latestAppVersion);
    String minimumSupportedVersion =
        remoteConfig.getString(ApiConstant.minimumSupportedAppVersion);

    log("latest_app_version : $latestAppVersion");
    log("minimum_supported_app_version : $minimumSupportedVersion");

    if ("${packageInfo.version}+${packageInfo.buildNumber}" ==
        latestAppVersion) {
      log("This is the latest version...");
    } else if ("${packageInfo.version}+${packageInfo.buildNumber}" ==
        minimumSupportedVersion) {
      log("The app is needed to update now...");
      showMandatoryUpdateDialog(context);
    } else {
      log("You can update the app...");
      showOptionalUpdateDialog(context);
    }

    listenForUpdate(context);
  }

  Future<void> listenForUpdate(BuildContext context) async {
    // listen the update data
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate().then((success) {
        log("This is from the remote config...");
        String latestAppVersion =
            remoteConfig.getString(ApiConstant.latestAppVersion);
        String minimumSupportedVersion =
            remoteConfig.getString(ApiConstant.minimumSupportedAppVersion);

        log("latest_app_version : $latestAppVersion");
        log("minimum_supported_app_version : $minimumSupportedVersion");

        if ("${packageInfo.version}+${packageInfo.buildNumber}" ==
            minimumSupportedVersion) {
          log("The app is needed to update now...");
          showMandatoryUpdateDialog(context);
        } else if ("${packageInfo.version}+${packageInfo.buildNumber}" ==
            latestAppVersion) {
          log("This is the latest version...");
        } else {
          log("You can update the app...");
          showOptionalUpdateDialog(context);
        }
      });
    });
  }

  Future<void> openInPlayStore() async {
    final Uri url = Uri.parse(AppConstants.appPlayStoreUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
