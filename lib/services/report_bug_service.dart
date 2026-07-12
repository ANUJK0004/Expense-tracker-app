import 'package:url_launcher/url_launcher.dart';

class ReportBugService {

  static Future<void> reportBug() async {

    final Uri email = Uri(

      scheme: "mailto",

      path: "support@nexsham.com",

      queryParameters: {

        "subject":"Bug Report",

      },

    );

    await launchUrl(email);

  }

}