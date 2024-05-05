import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:votivate/styles/styles.dart';
import 'package:votivate/subpages/account_page.dart';

import 'package:votivate/super_admin/pollhistory_super_admin.dart';

class SuperAdminHistory extends StatefulWidget {
  const SuperAdminHistory({super.key});

  @override
  State<SuperAdminHistory> createState() => _SuperAdminHistoryState();
}

class _SuperAdminHistoryState extends State<SuperAdminHistory> {
  CollectionReference electionHistoryCollection =
      FirebaseFirestore.instance.collection("election_history");
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Election History",
            style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
          ),
          backgroundColor: AppColors.bgColor,
          iconTheme: const IconThemeData(color: Colors.white),
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
        ),
        body: StreamBuilder(
          stream: electionHistoryCollection.snapshots(),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Card(
                      elevation: 4, // Add elevation for a raised look
                      child: ListTile(
                        title: Column(
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
                                    height: 50,
                                    width:
                                        50), // Show an empty SizedBox if no image URL is available
                            const SizedBox(
                                height:
                                    8), // Add spacing between image and title
                            Text(
                              optionText2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 31, 92, 1),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Date Created: ',
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Color for the first part of the text
                                  ),
                                  TextSpan(
                                    text: formattedDate,
                                    style: const TextStyle(
                                        color: Colors
                                            .blue), // Color for the pass code part
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Created by: ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '${optionText['author']}',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Election Code: ',
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Color for the first part of the text
                                  ),
                                  TextSpan(
                                    text: '${optionText['pass_code']}',
                                    style: const TextStyle(
                                        color: Colors
                                            .green), // Color for the pass code part
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        SuperAdminPage(optionData)),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 20, 150, 3),
                              ),
                              child: const Text(
                                "View",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 240, 237)),
                              ),
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
