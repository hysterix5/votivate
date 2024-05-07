import 'package:flutter/material.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00b4d8),
        iconTheme:
            const IconThemeData(color: Colors.white), // Set back button color
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(
              255, 226, 226, 226), // Set body background color
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VOTIVATE: Mobile Voting App - Terms and Conditions',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text('Last updated: April 09, 2024'),
              const SizedBox(height: 30.0),
              _buildTextWithBoldAsterisks(
                  '**Acceptance of Terms:** By downloading, accessing, or using the Votivate mobile voting app, you agree to comply with and be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, please do not use the App.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Purpose:** The App, developed by the KATRIBO PLUS Dev Team for Assumption College of Davao, is intended solely for the purpose of facilitating voting processes within the college community.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Access and Use:** Access to the App is limited to authorized users affiliated with Assumption College of Davao. You must not attempt to access or use the App if you are not an authorized user.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**User Conduct:** When using the App, you agree to abide by all applicable laws and regulations. You must not engage in any conduct that could disrupt the functioning of the App or compromise its security.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Privacy:** We are committed to protecting your privacy and personal information. By using the App, you consent to the collection, use, and disclosure of your information as described in our Privacy Policy.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Intellectual Property:** All intellectual property rights in the App, including but not limited to trademarks, copyrights, and patents, belong to the KATRIBO PLUS Dev Team and Assumption College of Davao. You may not reproduce, distribute, or modify the App without prior written consent.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Disclaimer:** The App is provided on an "as is" and "as available" basis, without any warranties or representations of any kind, express or implied. We do not guarantee that the App will be error-free or uninterrupted.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Limitation of Liability:** To the fullest extent permitted by law, we shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of the App.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Amendments:** We reserve the right to amend or update these Terms at any time without prior notice. Your continued use of the App following any changes constitutes acceptance of the updated Terms.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Governing Law:** These Terms shall be governed by and construed in accordance with the laws of the Philippines. Any disputes arising out of or relating to these Terms shall be subject to the exclusive jurisdiction of the courts of the Philippines.'),
              const SizedBox(height: 20.0),
              _buildTextWithBoldAsterisks(
                  '**Contact Us:** If you have any questions or concerns about these Terms, please contact us at:'),
              const SizedBox(height: 10.0),
              const Text(
                "developer.votivate@gmail.com.",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 30),
              const Text(
                'By using the Votivate mobile voting app, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions:',
              ),
              const SizedBox(height: 30),
              _buildTextWithBoldAsterisks(
                  '**Third-party Social Media Service:** means any services or content (including data, information, products, or services) provided by a third-party that may be displayed, included, or made available by the Service.'),
              const SizedBox(height: 10),
              _buildTextWithBoldAsterisks(
                  '**You:** means the individual accessing or using the Service, or the Developers, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'),
              const SizedBox(height: 20.0),
              const Text(
                'Thank you for using Votivate!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40.0),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextWithBoldAsterisks(String text) {
    final pattern = RegExp(r'\*\*([^*]+)\*\*');
    final matches = pattern.allMatches(text);
    List<TextSpan> textSpans = [];
    int previousEnd = 0;

    for (var match in matches) {
      final String normalText = text.substring(previousEnd, match.start);
      if (normalText.isNotEmpty) {
        textSpans.add(TextSpan(
            text: normalText, style: const TextStyle(color: Colors.black)));
      }
      textSpans.add(TextSpan(
        text: match.group(1),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));
      previousEnd = match.end;
    }

    final String remainingText = text.substring(previousEnd);
    if (remainingText.isNotEmpty) {
      textSpans.add(TextSpan(
          text: remainingText, style: const TextStyle(color: Colors.black)));
    }

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
