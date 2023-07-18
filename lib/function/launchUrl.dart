import 'package:url_launcher/url_launcher.dart';

launchURL(url) async {
  if (await canLaunchUrl(url)) {
    final bool nativeAppLaunchSucceeded = await launchUrl(url);
    if (!nativeAppLaunchSucceeded) {
      await launchURL(url);
    }
  } else {
    throw 'Could not launch $url';
  }
}