import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:votivate/styles/styles.dart';
import 'package:votivate/subpages/account_page.dart';
import 'package:votivate/voters/screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference electionCollection =
      FirebaseFirestore.instance.collection("active_elections");
  final TextEditingController _electionCodeController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset("assets/icons/votivate.png", height: 30.0),
            const SizedBox(
              width: 10.0,
            ),
            const Text("Votivate", style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const AccountPage()),
                ),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: electionCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var optionData = documents[index];
              var optionText = documents[index].data() as Map<String, dynamic>;
              var optionText2 = optionText['name'] as String?;
              var electionCode = optionText['pass_code'] as String?;
              Timestamp timestamp = optionData["date_created"];
              DateTime dateCreated =
                  timestamp.toDate(); // Convert Timestamp to DateTime
              String formattedDate = DateFormat('M/d/y').format(dateCreated);

              var participantsList =
                  optionText['participants'] as List<dynamic>?;

              Map<String, dynamic>?
                  currentUserVotes; // Assign the user's votes here

// Iterate through the participantsList to find the current user's votes
              if (participantsList != null) {
                for (var participants in participantsList) {
                  // Assuming there's some identifier for the current user, e.g., userID
                  if (participants['uid'] == user!.uid) {
                    // Found the current user's data, extract their votes
                    currentUserVotes = participants['votes'];
                    break;
                  }
                }
              }

              if (optionText2 != null) {
                bool isUserParticipant = participantsList != null &&
                    participantsList
                        .any((participant) => participant['uid'] == user!.uid);

                return GestureDetector(
                  onTap: () {
                    if (isUserParticipant) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Your Votes in this Election:"),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: currentUserVotes!.entries
                                    .map<Widget>((entry) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                8.0), // Add margin to the bottom
                                        child: Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black,
                                            // Add more title styles as needed
                                          ),
                                        ),
                                      ),
                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                16.0), // Add margin to the bottom
                                        child: Text(
                                          entry.value,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            // Add more content styles as needed
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            content: SizedBox(
                              height: 175.0,
                              width: 70.0,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      optionText2,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00b4d8)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextFormField(
                                      controller: _electionCodeController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Election Code',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (_electionCodeController.text.trim() ==
                                      electionCode) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            ElectionScreen(optionData)),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("Invalid Code"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00b4d8),
                                ),
                                child: const Text("Enter",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 8.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            optionData['logo'] != null
                                ? Image.network(
                                    optionData['logo'],
                                    width: 50, // Set width as needed
                                    height: 50, // Set height as needed
                                    fit: BoxFit
                                        .contain, // Adjust the image fit as needed
                                  )
                                : Image.asset('assets/icons/acd_logo.png',
                                    height: 50, width: 50),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  optionText2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.today,
                                        color:
                                            Colors.black), // Icon for schedule
                                    const SizedBox(
                                        width:
                                            4), // Add some spacing between the icon and date
                                    Text(
                                      formattedDate, // Replace this with the actual creation date
                                      style: const TextStyle(
                                          color: Colors
                                              .black), // Adjust styling as needed
                                    ),
                                  ],
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Participation Status: ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      if (isUserParticipant)
                                        const TextSpan(
                                          text:
                                              'Done voting!', // Your message when user is registered
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      else
                                        const TextSpan(
                                          text:
                                              'Not voted yet', // Your message when user has not voted
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("No Elections at the moment",
                      style: TextStyle(color: Color(0xFF00b4d8))),
                );
              }
            },
          );
        },
      ),
    );
  }
}
