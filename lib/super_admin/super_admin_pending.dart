import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:votivate/admin/edit_election.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:votivate/subpages/account_page.dart';
import 'package:votivate/admin/create_election.dart';
import 'package:intl/intl.dart';
import 'package:votivate/styles/styles.dart';
import 'package:cool_alert/cool_alert.dart';

class SuperAdminPendingPage extends StatefulWidget {
  const SuperAdminPendingPage({super.key});

  @override
  State<SuperAdminPendingPage> createState() => _SuperAdminPendingPageState();
}

class _SuperAdminPendingPageState extends State<SuperAdminPendingPage> {
  CollectionReference electionCollection =
      FirebaseFirestore.instance.collection("pending_elections");
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
                "Pending Elections",
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
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column containing logo, title, date, and code
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
                                        text: 'Created by: ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: '${optionText['author']}',
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
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                EditElection(optionData)),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 20, 150, 3),
                                      ),
                                      child: const Text(
                                        "Manage Election",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 238, 240, 237),
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          showCancelBtn: true,
                                          title: "Confirm Release",
                                          text:
                                              "Are you sure to activate election '$optionText2'?",
                                          confirmBtnText: 'Yes',
                                          cancelBtnText: 'No',
                                          confirmBtnColor: Colors.green,
                                          onConfirmBtnTap: () {
                                            dataProvider.releaseElection(
                                              electionId: optionData.id,
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 20, 150, 3),
                                      ),
                                      child: const Text(
                                        "Activate Election",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 238, 240, 237),
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.warning,
                                      showCancelBtn: true,
                                      text:
                                          'Are you sure to delete this pending election?',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No',
                                      confirmBtnColor: Colors.red,
                                      onConfirmBtnTap: () {
                                        dataProvider.deleteElection(
                                          electionId: optionData.id,
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    "Delete Election",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 238, 240, 237),
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                width: 12), // Adding space between columns
                            // Right column containing buttons
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateElection(),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 2, 139, 6),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
