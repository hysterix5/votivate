import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votivate/admin/create_polls.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:votivate/styles/styles.dart';

class EditElection extends StatefulWidget {
  final DocumentSnapshot optionData;
  const EditElection(this.optionData, {super.key});

  @override
  State<EditElection> createState() => _EditElectionState();
}

class _EditElectionState extends State<EditElection> {
  late String electionId;
  late CollectionReference pollCollection;

  @override
  void initState() {
    super.initState();
    electionId = widget.optionData.id;
    CollectionReference electionCollection =
        FirebaseFirestore.instance.collection("pending_elections");
    DocumentReference electionDoc = electionCollection.doc(electionId);
    pollCollection = electionDoc.collection("polls");
    // Call a method to fetch data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Election",
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pollCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No polls at the Moment"));
          }
          final polls = snapshot.data!.docs;

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: List.generate(polls.length, (index) {
                          final data = polls[index];
                          Map poll = data["poll"];
                          List<dynamic> options = poll["poll_options"];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryColor,
                              border: Border.all(color: AppColors.bgColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    poll["poll_question"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: Consumer<DataProvider>(
                                      builder: (context, delete, child) {
                                    return IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Confirm delete"),
                                              content: Text(
                                                  "Are you sure you want to delete '${poll["poll_question"]}'?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    delete.deletePoll(
                                                      electionId: electionId,
                                                      pollId: data.id,
                                                    );

                                                    Navigator.of(context)
                                                        .pop(); // Close the current dialog

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: const Text(
                                                              "Deleted successfully"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "Ok"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the current dialog
                                                  },
                                                  child: const Text("No"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                      color:
                                          const Color.fromARGB(255, 228, 2, 2),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 10),
                                ...List.generate(options.length, (index) {
                                  final dataoption = options[index];
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height:
                                                      60, // Adjust the overall height of the container
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Add border radius for a more polished look
                                                    color: const Color.fromARGB(
                                                        255,
                                                        240,
                                                        240,
                                                        240), // Background color for the container
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: dataoption[
                                                                    'image'] !=
                                                                null
                                                            ? ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  dataoption[
                                                                      'image'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.person,
                                                                size:
                                                                    40, // Adjust the size of the icon
                                                                color: Colors
                                                                    .grey, // Change the color of the icon as desired
                                                              ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          dataoption["options"],
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .accentColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      (dataoption["votecount"] /
                                                          100), // Width as a percentage of screen width
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8), // Match the container's border radius
                                                      color: AppColors.bgColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                })
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePoll(electionId),
            ),
          );
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
