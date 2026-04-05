import 'package:url_launcher/url_launcher.dart';

Future<void> openUrlInWeb(
  String url, {
  LaunchMode? mode,
}) async {
  final Uri parsedUrl = Uri.parse(url);

  if (!await launchUrl(
    parsedUrl,
    mode: mode ?? LaunchMode.platformDefault,
  )) {
    throw 'Could not launch $parsedUrl';
  }
}
