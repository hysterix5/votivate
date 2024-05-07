import 'package:flutter/material.dart';
import 'package:votivate/styles/styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The Team behind the Best Capstone Project Votivate:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 210.0),
              Image.asset('assets/icons/katribo.png', height: 200),
              const SizedBox(height: 210.0),
              _buildMemberTile(
                name: 'Joseph Mel Resty Denopol',
                course: 'Bachelor of Science in Information Technology',
                college: 'Assumption College of Davao',
                position:
                    'LITS Vice President for External Affairs S.Y 2023-2024',
                summary:
                    'An exceptional Project Head Programmer spearheading the development of the Votivate mobile voting app, recognized also as the Best Capstone Presentor during the development of this project. With mastery in multiple programming languages, and orchestrates the success of the project with precision and innovation, ensuring its seamless execution and unprecedented impact.',
                imagePath: 'assets/img/seph.png',
              ),
              _buildMemberTile(
                name: 'Rizalyn Batalla',
                course: 'Bachelor of Science in Information Technology',
                college: 'Assumption College of Davao',
                position:
                    'LITS 2nd year Class Representative, LITS Assistant Secretary',
                summary:
                    'A dedicated Technical Writer acknowledged for the pivotal contribution to the best capstone project - Votivate mobile voting app. Skilled in HTML5, CSS, JavaScript, PHP, Laravel, and adept project management. Possesses strategic thinking abilities and effective communication skills.',
                imagePath: 'assets/img/riza.png',
              ),
              _buildMemberTile(
                name: 'John Ariel Rullan',
                course: 'Bachelor of Science in Information Technology',
                college: 'Assumption College of Davao',
                position:
                    'LITS 3rd year Class Representative, SIDLAC President, Himig Assumptionista Co-founder and President, SiPAG founder and President',
                summary:
                    'Passionate UI designer known for contributing to winning capstone project (Votivate - Mobile voting app). Proficient in frontend development that brings creativity and innovation to every project.',
                imagePath: 'assets/img/kuya.png',
              ),
              _buildMemberTile(
                name: 'James Carlo Reponte',
                course: 'Bachelor of Science in Information Technology',
                college: 'Assumption College of Davao',
                position:
                    'A dedicated Project Analyst pivotal in developing the Best Capstone project - Votivate mobile voting app. Proficient in HTML5, CSS, JavaScript, PHP, Laravel. Applies analytical procedures for smooth project planning and adeptly resolves challenges during planning and deployment stages.',
                summary: '',
                imagePath: 'assets/img/reponte.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTile({
    required String name,
    required String course,
    required String college,
    required String position,
    required String summary,
    required String imagePath,
  }) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
// Adjust the height of the image
            width: double.infinity, // Make the image fill the width
            fit: BoxFit.fitWidth, // Ensure the image covers the space
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            course,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            college,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            position,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
