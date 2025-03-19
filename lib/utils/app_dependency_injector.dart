import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

final GetIt getIt = GetIt.instance;

void setupLocator()async{
  // firebase remote config
  getIt.registerSingleton<FirebaseRemoteConfig>(FirebaseRemoteConfig.instance);
  // Package info
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  getIt.registerSingleton<PackageInfo>(packageInfo);
}