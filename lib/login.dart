import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restart_app/restart_app.dart';
import 'package:votivate/admin/home_admin.dart';
import 'package:votivate/screens/agree_screen.dart';
import 'package:votivate/styles/styles.dart';
import 'package:votivate/super_admin/super_admin_dashboard.dart';
import 'package:votivate/provider/auth_provider.dart';
import 'package:votivate/utilities/messages.dart';
import 'package:votivate/utilities/router.dart';
import 'package:votivate/voters/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset('assets/icons/acd_logo.png',
                    height: 65.0, width: 65.0),
                const SizedBox(height: 5),
                const Text("Assumption College of Davao",
                    style: TextStyle(fontSize: 16)),
                const Text("J.P Cabaguio Avenue, Davao City",
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 75.0),
                Image.asset(
                  'assets/icons/votivate2.png',
                  height: 150.0,
                ),
                const SizedBox(height: 25.0),
                const Text('Welcome Assumptionista!',
                    style: TextStyle(
                      fontSize: 23,
                    )),
                const Text(
                  'Use your ACD Google Suite account to login to Votivate',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    final authResult =
                        await AuthenticateProvider().signInWithGoogle();
                    User? user = authResult.user;

                    if (user == null) {
                      // Handle unsuccessful sign-in
                      error(context, message: "Please try again");
                    } else {
                      if (user.email?.endsWith("@acdeducation.com") ?? false) {
                        final userSnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get();

                        final program = userSnapshot['program'];

                        if (userSnapshot.exists) {
                          Map<String, dynamic> userData =
                              userSnapshot.data() as Map<String, dynamic>;
                          int? accessLevel = userData['access_level'] as int?;
                          if (accessLevel == 1) {
                            print(program);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const HomePage()),
                              ),
                            );
                          } else if (accessLevel == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const AdminHomePage()),
                              ),
                            );
                          } else if (accessLevel == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    const SuperAdminDashboard()),
                              ),
                            );
                          }
                        } else {
                          // User doesn't exist in the Firestore database
                          nextPageOnly(context, AgreeScreen());
                        }
                      } else {
                        await showGoogleLoginDialog(context);
                      }
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/google_icon.png',
                            width: 30.0, height: 30.0),
                        const SizedBox(width: 10.0),
                        const Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 125.0,
                ),
                const Text(
                  'Developed by',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                Image.asset('assets/icons/katribo.png', height: 35.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showGoogleLoginDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Color.fromRGBO(255, 30, 0, 1),
                      size: 30.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Invalid Email',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(56, 119, 236, 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Please use your ACD\'s Google Suite',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    AuthenticateProvider().logOut().then((value) {
                      Restart.restartApp();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
