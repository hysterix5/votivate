import 'package:flutter/material.dart';
import 'package:votivate/screens/welcome.dart';
import 'package:votivate/styles/styles.dart';

class AgreeScreen extends StatefulWidget {
  @override
  State<AgreeScreen> createState() => _AgreeScreenState();
}

class _AgreeScreenState extends State<AgreeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Votivate: Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.bgColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/votivate2.png',
                      height: 75.0,
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Image.asset(
                      'assets/icons/osa.png',
                      height: 75.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Last updated: April 09, 2024',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Interpretation and Definitions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Interpretation: The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Definitions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Application: The software program provided by the KATRIBO PLUS Dev Team downloaded by You on any electronic device, named Votivate.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- The term "Application Store" refers to digital distribution services such as the Apple Inc. App Store or Google Inc. Play Store, where applications are typically made available for download. However, it\'s worth noting that our application, developed by the KATRIBO PLUS Dev Team as a capstone project at Assumption College of Davao, utilizing Flutter and Firebase, is not listed on either the Apple App Store or Google Play Store. Instead, it is accessible for download through external links provided by our team.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Affiliate: An entity that controls, is controlled by, or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest, or other securities entitled to vote for the election of directors or other managing authority.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Country: Refers to the Philippines.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Developers: Referred to as either "the Development Team", "We", "Us" or "Our" in this Agreement, refers to the KATRIBO PLUS Development Team.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Device: An Android cellphone or an Android digital tablet.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '- Service: Refers to the Application.',
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Acceptance of Terms:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'By downloading, accessing, or using the Votivate mobile voting app ("the App"), you agree to comply with and be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, please do not use the App.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Purpose:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'The App, developed by the KATRIBO PLUS Dev Team for Assumption College of Davao, is intended solely for the purpose of facilitating voting processes within the college community.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Access and Use:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Access to the App is limited to authorized users affiliated with Assumption College of Davao. You must not attempt to access or use the App if you are not an authorized user.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'User Conduct:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'When using the App, you agree to abide by all applicable laws and regulations. You must not engage in any conduct that could disrupt the functioning of the App or compromise its security.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Privacy:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'We are committed to protecting your privacy and personal information. By using the App, you consent to the collection, use, and disclosure of your information as described in our Privacy Policy.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Intellectual Property:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'All intellectual property rights in the App, including but not limited to trademarks, copyrights, and patents, belong to the KATRIBO PLUS Dev Team and Assumption College of Davao. You may not reproduce, distribute, or modify the App without prior written consent.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Disclaimer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'The App is provided on an "as is" and "as available" basis, without any warranties or representations of any kind, express or implied. We do not guarantee that the App will be error-free or uninterrupted.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Limitation of Liability:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'To the fullest extent permitted by law, we shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of the App.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Amendments:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'We reserve the right to amend or update these Terms at any time without prior notice. Your continued use of the App following any changes constitutes acceptance of the updated Terms.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Governing Law:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'These Terms shall be governed by and construed in accordance with the laws of the Philippines. Any disputes arising out of or relating to these Terms shall be subject to the exclusive jurisdiction of the courts of the Philippines.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Contact Us:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'If you have any questions or concerns about these Terms, please contact us at developer.votivate@gmail.com.',
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'By using the Votivate mobile voting app, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 150.0),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _isButtonEnabled
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Welcome(),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          color: _isButtonEnabled ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: const Text(
                          'Agree',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isButtonEnabled
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          color: _isButtonEnabled ? Colors.red : Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: const Text(
                          'Disagree',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
