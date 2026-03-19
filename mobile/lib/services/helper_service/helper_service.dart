import 'package:url_launcher/url_launcher_string.dart';

abstract class HelperService {
  static Future<void> launchURL(
    String url, {
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) async {
    if (!await launchUrlString(url, mode: launchMode)) {
      throw Exception('Could not launch $url');
    }
  }
}
