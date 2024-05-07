import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:votivate/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If there is no internet connection, show a dialog and close the app
      await showNoInternetDialog();
    } else {
      // If there is an internet connection, add a delay before navigating to the next page
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      });
    }
  }

  Future<void> showNoInternetDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please connect to the internet to use this app.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the app
              Navigator.of(context).pop();
              exit(0);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your splash screen logo or image goes here
            Lottie.asset(
              'assets/anim/votivate_anim.json',
              width: 350,
              height: 500,
              fit: BoxFit.fill,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  const Text("Developed by:"),
                  Image.asset(
                    'assets/icons/katribo.png',
                    height: 75,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
