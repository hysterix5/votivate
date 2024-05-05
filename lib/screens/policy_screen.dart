import 'package:flutter/material.dart';
import 'package:votivate/screens/agreement.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Policy", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF00b4d8),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.policy, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 218, 217, 217),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Assumption College of Davao Logo
                Image.asset(
                  'assets/icons/acd_logo.png',
                  height: 90.0,
                  width: 90.0,
                ),

                // Votivate Logo
                Image.asset(
                  'assets/icons/votivate.png',
                  height: 100.0,
                  width: 100.0,
                ),
              ],
            ),

            const SizedBox(height: 50.0),
            const Divider(height: 1, thickness: 1, color: Color(0xFF00b4d8)),
            const SizedBox(height: 20.0),

            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00b4d8),
              ),
            ),
            const Text(
              "Votivate is committed to protecting the privacy of its users. We collect and store only the necessary information required for the functioning of the app, such as user accounts and voting history. We do not share personal information with third parties without user consent.",
              style: TextStyle(fontSize: 16.0),
            ),

            const SizedBox(height: 50.0),
            const Divider(height: 1, thickness: 1, color: Color(0xFF00b4d8)),
            const SizedBox(height: 16.0),
            const Text(
              "Data Collection",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00b4d8),
              ),
            ),
            const Text(
              "Votivate may collect anonymized usage data for the purpose of improving the app's performance and user experience. This data includes, but is not limited to, device information, app usage statistics, and error logs.",
              style: TextStyle(fontSize: 16.0),
            ),

            const SizedBox(height: 50.0),
            const Divider(height: 1, thickness: 1, color: Color(0xFF00b4d8)),
            const SizedBox(height: 16.0),
            const Text(
              "Security Measures",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00b4d8),
              ),
            ),
            const Text(
              "As we utilize our school's Google Suite account, students are not required to create a separate account on Votivate. Instead, they log in using their ACD Google Suite credentials."
              "To ensure the security of user data, we employ "
              "industry-standard security measures to protect against unauthorized access, "
              "disclosure, alteration, and destruction. While users do not set individual "
              "passwords for Votivate accounts, we strongly recommend maintaining the "
              "security of their Google accounts by utilizing robust and unique passwords. "
              "This practice enhances overall account security and contributes to a safer "
              "user experience.",
              style: TextStyle(fontSize: 16.0),
            ),

            const SizedBox(height: 50.0),
            const Divider(height: 1, thickness: 1, color: Color(0xFF00b4d8)),
            const SizedBox(height: 16.0),
            const Text(
              "User Consent",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00b4d8),
              ),
            ),
            const Text(
              "By using the Votivate app, users agree to the terms outlined in this policy. Users have the right to control their data and can request the deletion of their accounts at any time.",
              style: TextStyle(fontSize: 16.0),
            ),

            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgreementPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF00b4d8), // Change the button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Click here",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50.0),
            const Divider(height: 1, thickness: 1, color: Color(0xFF00b4d8)),
            const SizedBox(height: 16.0),
            const Text(
              "Terms of Service",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00b4d8),
              ),
            ),
            const Text(
              "By using the Votivate app, you agree to abide by the terms and conditions outlined in this document. Users are responsible for maintaining the confidentiality of their account credentials. Any misuse of the app, including attempts to manipulate voting results or violate the integrity of the voting process, will result in appropriate actions, including account suspension.",
              style: TextStyle(fontSize: 16.0),
            ), // Add more policy content as needed
          ]),
        ),
      ),
    );
  }
}
