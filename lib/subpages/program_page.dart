import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:votivate/voters/home.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  String selectedProgram = '';

  setSelectedProgram(String value) {
    setState(() {
      selectedProgram = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Votivate",
          style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
        ),
        backgroundColor: const Color.fromARGB(255, 13, 131, 2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              "Select your Program",
              style: TextStyle(
                  fontSize: 30.0, color: Color.fromRGBO(49, 49, 49, 1)),
            ),
            const SizedBox(
              height: 50.0,
            ),

            // RadioListTiles with separators
            for (String program in [
              'BSHM',
              'BSIT',
              'BSBA',
              'BSED',
              'BEED',
              'BSSW'
            ])
              Column(
                children: [
                  RadioListTile(
                    title: Text(program),
                    value: program,
                    groupValue: selectedProgram,
                    onChanged: (value) {
                      setSelectedProgram(value.toString());
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),

            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 13, 131, 2), // Button color
                  textStyle: const TextStyle(color: Colors.white), // Text color
                  elevation: 5, // Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .set({
                    "email": user?.email,
                    "name": user?.displayName,
                    "uid": user?.uid,
                    "access_level": 1,
                    "program": selectedProgram,
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const HomePage()),
                    ),
                  );
                },
                child: const Text("Submit",
                    style:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
