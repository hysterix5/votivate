import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:votivate/subpages/account_page.dart';
import 'package:votivate/admin/poll_admin.dart';
import 'package:intl/intl.dart';
import 'package:votivate/styles/styles.dart';

class AdminActivePage extends StatefulWidget {
  const AdminActivePage({super.key});

  @override
  State<AdminActivePage> createState() => _AdminActivePageState();
}

class _AdminActivePageState extends State<AdminActivePage> {
  CollectionReference electionCollection =
      FirebaseFirestore.instance.collection("active_elections");
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/icons/votivate.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                "My Active Elections",
                style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
              ),
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
              icon: const Icon(Icons.person),
            ),
          ],
          backgroundColor: AppColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder(
          stream: electionCollection
              .where('author_id', isEqualTo: user?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            var documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var optionData = documents[index];
                var optionText =
                    documents[index].data() as Map<String, dynamic>;
                var optionText2 = optionText['name'] as String?;

                Timestamp timestamp = optionText['date_created'];
                DateTime dateTime = timestamp.toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(dateTime);

                if (optionText2 != null) {
                  List<dynamic> participants = optionText['participants'] ?? [];
                  int participantsCount = participants.length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                optionData['logo'] != null
                                    ? Image.network(
                                        optionData['logo'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/icons/acd_logo.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                const SizedBox(height: 8),
                                Text(
                                  optionText2,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 31, 92, 1),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Date Created: ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: formattedDate,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Election Code: ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: '${optionText['pass_code']}',
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.groups,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(participantsCount.toString()),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                                width: 12), // Adding space between columns
                            // Right column containing buttons
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            ActivePollPage(optionData)),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 20, 150, 3),
                                  ),
                                  child: const Text(
                                    "View Election",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 238, 240, 237)),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm end"),
                                          content: Text(
                                              "Are you sure to end election '$optionText2'?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                dataProvider.endElection(
                                                  electionId: optionData.id,
                                                );
                                              },
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                  ),
                                  child: const Text(
                                    "End Election",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 238, 240, 237)),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            optionText['pass_code'])
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Election Code copied to clipboard')),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.copy),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  const Text("No Elections at the moment");
                }

                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
