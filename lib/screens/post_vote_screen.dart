import 'package:flutter/material.dart';
import 'package:votivate/voters/home.dart';

class PostVote extends StatelessWidget {
  const PostVote({Key? key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true; // Return true to allow popping the route
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'assets/icons/votivate.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Thank you for your participation in this Election!",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: const Text("Done!"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
