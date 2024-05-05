import 'package:flutter/material.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00b4d8),
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 226, 226, 226), // Set body background color
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VOTIVATE Mobile Voting App - Terms and Conditions',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text('Last Updated: December 10, 2023'),
              SizedBox(height: 10.0),
             Text(
                '1. Acceptance of Terms: By using the VOTIVATE mobile voting app, you agree to comply with and be bound by these terms and conditions. If you do not agree, please refrain from using the app.',
              ),
              SizedBox(height: 10.0),
              Text(
                '2. User Eligibility: VOTIVATE is intended for use by members of the Assumption College of Davao community. Users must be of legal voting age and authorized by the institution to participate in voting activities through the app.'
              ),
              SizedBox(height: 10.0),
              Text(
                '3.   Account Security: Users are responsible for maintaining the security of their VOTIVATE accounts, including passwords. Any unauthorized use of accounts must be reported immediately to the app administrator.',
              ),
              SizedBox(height: 10.0),
              Text(
                '4.   Voting Integrity: Users agree to cast their votes truthfully and without any attempt to manipulate the apps functionality. Any fraudulent activity will result in the disqualification of the vote and may lead to further consequences.',
              ),
              SizedBox(height: 10.0),
              Text(
                '5.   Privacy Policy: The app collects and processes personal data in accordance with its Privacy Policy. By using VOTIVATE, you consent to the apps data practices outlined in the Privacy Policy.',
              ),
              SizedBox(height: 10.0),
              Text(
                '6.   App Updates: KATRIBO Plus reserves the right to update, modify, or discontinue VOTIVATE, including any features or functionalities, at any time without prior notice.',
              ),
              SizedBox(height: 10.0),
              Text(
                '7.   Intellectual Property: All intellectual property rights related to VOTIVATE, including but not limited to trademarks, logos, and content, are the property of KATRIBO Plus.',
              ),
              SizedBox(height: 10.0),
              Text(
                '8.  Disclaimer of Warranty: VOTIVATE is provided "as is" without any warranties. KATRIBO Plus does not guarantee the accuracy, reliability, or availability of the app.',
              ),
              SizedBox(height: 10.0),
              Text(
                '9. Limitation of Liability: KATRIBO Plus is not liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or inability to use VOTIVATE.',
              ),
              SizedBox(height: 10.0),
              Text(
                'Contact Information: For inquiries or concerns about VOTIVATE, please contact the app administrator at developer@acdeducation.com.'
                  'By using VOTIVATE, you acknowledge that you have read, understood, and agree to these terms and conditions. KATRIBO Plus reserves the right to update or modify these terms at any time. It is your responsibility to review these terms periodically.'
                      'Thank you for using VOTIVATE!,'
              ),


              SizedBox(height: 10),
              Text(
                'Thank you for using VOTIVATE!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),

              SizedBox(height: 20.0),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
