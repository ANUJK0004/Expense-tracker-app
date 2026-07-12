import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Privacy Policy"),

      ),

      body: const Padding(

        padding: EdgeInsets.all(16),

        child: SingleChildScrollView(

          child: Text("""

Privacy Policy

Exes stores all transactions locally on your device.

We do not collect personal information.

Exported files remain under your control.

No data is uploaded to any server.

No advertisements track your usage.

For support contact:

support@nexsham.com

Version 1.0

© Nexsham Technologies

"""),

        ),

      ),

    );

  }

}