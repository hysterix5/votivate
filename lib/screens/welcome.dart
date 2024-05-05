import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:votivate/subpages/program_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      // 2. Pass that key to the `IntroductionScreen` `key` param
      key: _introKey,
      next: const Text(
        "Next",
        style: TextStyle(color: Colors.green),
      ),
      done: const Text(
        "Vote Now!",
        style: TextStyle(color: Colors.green),
      ),
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProgramPage(),
          ),
        );
      },
      pages: [
        PageViewModel(
          title: 'Let your voice be heard!',
          bodyWidget: Column(
            children: [
              const Text(
                "It is your right to vote, and the future of this club relies in your hands.",
                style: TextStyle(
                  fontSize: 16.0, // Adjust the font size as needed
                ),
                textAlign:
                    TextAlign.center, // Adjust the text alignment as needed
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0), // Adjust the top padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/acd_logo.png",
                          height: 70.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/votivate.png",
                          height: 70.0),
                    ),
                  ],
                ),
              )
            ],
          ),
          image: Container(
            margin:
                const EdgeInsets.only(top: 50.0), // Adjust top margin as needed
            child: Center(
              child: Image.asset("assets/icons/img_announcing_1.png",
                  height: 175.0),
            ),
          ),
        ),
        PageViewModel(
          title: 'Be Vigilant!',
          bodyWidget: Column(
            children: [
              const Text(
                "Report electoral violence, as quickly as possible",
                style: TextStyle(
                  fontSize: 16.0, // Adjust the font size as needed
                ),
                textAlign:
                    TextAlign.center, // Adjust the text alignment as needed
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0), // Adjust the top padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/acd_logo.png",
                          height: 70.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/votivate.png",
                          height: 70.0),
                    ),
                  ],
                ),
              )
            ],
          ),
          image: Center(
              child:
                  Image.asset("assets/icons/img_arrest_1.png", height: 175.0)),
        ),
        PageViewModel(
          title: 'Make a Difference!',
          bodyWidget: Column(
            children: [
              const Text(
                "Transform your aspirations into action, ensuring every voice matters in a dynamic democracy.",
                style: TextStyle(
                  fontSize: 16.0, // Adjust the font size as needed
                ),
                textAlign:
                    TextAlign.center, // Adjust the text alignment as needed
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0), // Adjust the top padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/acd_logo.png",
                          height: 70.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0), // Adjust the spacing as needed
                      child: Image.asset("assets/icons/votivate.png",
                          height: 70.0),
                    ),
                  ],
                ),
              )
            ],
          ),
          image: Center(
              child: Image.asset("assets/icons/img_dfhs_1.png", height: 175.0)),
        ),
      ],
      showNextButton: true,
      showDoneButton: true,
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.green,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
