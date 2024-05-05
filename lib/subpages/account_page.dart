import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votivate/provider/auth_provider.dart';
import 'package:votivate/screens/about.dart';
import 'package:votivate/styles/styles.dart';
import 'package:votivate/utilities/messages.dart';
import 'package:restart_app/restart_app.dart';
import 'package:votivate/screens/policy_screen.dart';
import 'package:votivate/screens/agreement.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Placeholder for voting status (replace with actual logic)
  bool hasVoted = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? photoUrl = user?.photoURL;
    String? displayName = user?.displayName;
    String? email = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Use actions instead of trailing
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/votivate2.png',
                  height: 100.0,
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            CircleAvatar(
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              radius: 70,
            ),
            const SizedBox(height: 20.0),
            Text(
              displayName ?? "",
              style: const TextStyle(
                fontSize: 25.0,
                color: Color.fromARGB(255, 71, 71, 71),
                // fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              email ?? "",
              style: const TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 1, 123, 139),
              ),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const PolicyScreen()),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.policy, color: Color.fromARGB(255, 0, 60, 71)),
                    SizedBox(width: 4.0),
                    Text(
                      "Policy",
                      style: TextStyle(color: Color.fromARGB(255, 0, 60, 71)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 200.0,
              height: 10.0,
              child: Divider(
                  height: 0.5,
                  thickness: 1.0,
                  color: Color.fromARGB(255, 131, 145, 148)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgreementPage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment,
                        color: Color.fromARGB(255, 0, 60, 71)),
                    SizedBox(width: 4),
                    Text(
                      "User Agreement",
                      style: TextStyle(color: Color.fromARGB(255, 0, 60, 71)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    showCancelBtn: true,
                    title: "Logging out?",
                    text: "Are you sure you want to Log out?",
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.blue,
                    onConfirmBtnTap: () {
                      AuthenticateProvider().logOut().then((value) {
                        if (value == false) {
                          error(context, message: "Please try again");
                        } else {
                          Restart.restartApp();
                        }
                      });
                    },
                  );
                  // AuthenticateProvider().logOut().then((value) {
                  //   if (value == false) {
                  //     error(context, message: "Please try again");
                  //   } else {
                  //     Restart.restartApp();
                  //   }
                  // });
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/katribo.png',
                  height: 40.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Image.asset(
                  'assets/icons/acd_logo.png',
                  height: 40.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
