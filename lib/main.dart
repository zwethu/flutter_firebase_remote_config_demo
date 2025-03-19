import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remote_config_demo/screens/home_page.dart';
import 'package:flutter_remote_config_demo/utils/app_dependency_injector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase setup
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // initialize the get_it locator
    setupLocator();

    // remoteConfig setup
    final remoteConfig = getIt<FirebaseRemoteConfig>();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 30),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );

    // set default values and fetch from server
    await remoteConfig.setDefaults({
      "latest_app_version": "-2.0.0",
      "minimum_supported_app_version": "-1.0.0",
    });
    await remoteConfig.fetchAndActivate();

    // getting app info from the package info library
    PackageInfo packageInfo = getIt<PackageInfo>();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    log("AppName : $appName");
    log("Package Name : $packageName");
    log("Version : $version");
    log("Build Number : $buildNumber");

  } on FirebaseException catch (e) {
    log("Error : ${e.toString()}");
  } on Exception catch (e) {
    log("Error : ${e.toString()}");
  } finally {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Remote Config Demo',
      home: HomePage(),
    );
  }
}
