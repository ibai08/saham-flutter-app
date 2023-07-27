import 'package:url_launcher/url_launcher.dart';

launchURL(url) async {
  if (await launchURL(url)) {
    final bool nativeAppLaunchSucceeded = await launchURL(url);
    if (!nativeAppLaunchSucceeded) {
      await launchURL(url);
    }
  } else {
    throw 'Could not launch $url';
  }
}