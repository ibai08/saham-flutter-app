import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saham_01_app/core/config.dart';

Future<bool> versionCheck() async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.buildNumber.trim());
  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig?.fetchAndActivate();
    remoteConfig?.getString('force_update_current_version');
    double newVersion = double.parse(
        remoteConfig!.getString('force_update_current_version').trim());
    if (newVersion > currentVersion) {
      return true;
    }
  } on FirebaseException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
  return false;
}