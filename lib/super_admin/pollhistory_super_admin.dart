import 'package:flutter/material.dart' hide Border;
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminPage extends StatefulWidget {
  final DocumentSnapshot optionData;
  const SuperAdminPage(this.optionData, {Key? key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  late String electionId;
  late CollectionReference pollCollection;

  @override
  void initState() {
    super.initState();
    electionId = widget.optionData.id;
    CollectionReference electionCollection =
        FirebaseFirestore.instance.collection("election_history");
    DocumentReference electionDoc = electionCollection.doc(electionId);
    pollCollection = electionDoc.collection("polls");
  }

  // void exportToExcel(List<Map<String, dynamic>> data) async {
  //   // Request storage permission
  //   var status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     // Permission already granted, proceed with exporting to Excel
  //     exportToExcel(data);
  //   } else {
  //     // Permission not granted, request it
  //     status = await Permission.storage.request();
  //     if (status.isGranted) {
  //       // Permission granted, proceed with exporting to Excel
  //       exportToExcel(data);
  //     }
  //   }
  //   // Create Excel workbook
  //   var excel = Excel.createExcel();

  //   // Add sheet
  //   var sheet = excel['Poll Data'];

  //   // Add headers
  //   sheet.appendRow([
  //     const TextCellValue("Poll Question"),
  //     const TextCellValue("Option"),
  //     const TextCellValue("Vote Count")
  //   ]);

  //   // Add data rows
  //   for (var poll in data) {
  //     sheet.appendRow([
  //       TextCellValue(poll["poll_question"]),
  //       TextCellValue(poll["option"]),
  //       TextCellValue(poll["vote_count"].toString())
  //     ]);
  //   }

  //   // Save the Excel file
  //   var fileBytes = excel.save();
  //   var directory = await getApplicationDocumentsDirectory();

  //   File(join('$directory/output_file_name.xlsx'))
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(fileBytes!);
  // }

  void showParticipantsDialog(BuildContext context, String electionId) async {
    try {
      CollectionReference electionCollection =
          FirebaseFirestore.instance.collection("election_history");
      DocumentSnapshot electionDoc =
          await electionCollection.doc(electionId).get();

      if (electionDoc.exists) {
        List<dynamic>? participants = electionDoc['participants'];
        List<String> participantNames = [];

        if (participants != null && participants.isNotEmpty) {
          for (dynamic participant in participants) {
            String? name = participant['name'];
            if (name != null && name.isNotEmpty) {
              participantNames.add(name);
            }
          }
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Election Participants'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showSearchDialog(context, participantNames);
                      },
                      child: const Text('Search Participants'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Participants:'),
                    ...participantNames.map((name) {
                      return ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     exportToExcel(participantNames
                    //         .map((name) => {
                    //               "poll_question": "Participants",
                    //               "option": name,
                    //               "vote_count": 0
                    //             })
                    //         .toList());
                    //   },
                    //   child: const Text('Export to Excel'),
                    // ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print("No document found with ID: $electionId");
      }
    } catch (e) {
      print("Error fetching participants: $e");
    }
  }

  void showSearchDialog(BuildContext context, List<String> participantNames) {
    String searchTerm = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Participants'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  searchTerm = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close search dialog
                    },
                    child: const Text('Close'),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<String> filteredParticipants = participantNames
                          .where((name) => name
                              .toLowerCase()
                              .contains(searchTerm.toLowerCase()))
                          .toList();
                      Navigator.pop(context); // Close search dialog
                      showFilteredParticipantsDialog(
                          context, filteredParticipants);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showFilteredParticipantsDialog(
      BuildContext context, List<String> filteredParticipants) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtered Participants'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filteredParticipants.map((name) {
                return ListTile(
                  title: Text(
                    name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 2, 136, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              showParticipantsDialog(context, widget.optionData.id);
            },
            icon: const Icon(Icons.groups, color: Colors.white),
          ),
        ],
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    poll["poll_question"],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 2, 139, 14),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
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
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (dataoption[
                                                                  'image'] !=
                                                              null) {
                                                            // Show full-size image in a dialog
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Dialog(
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        300, // Adjust the height as per your requirement
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(dataoption['image']),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            // Show dialog with message
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Image Not Available'),
                                                                  content:
                                                                      const Text(
                                                                          'Sorry, the image is not available.'),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: dataoption[
                                                                      'image'] !=
                                                                  null
                                                              ? ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    dataoption[
                                                                        'image'],
                                                                    fit: BoxFit
                                                                        .cover, // Use BoxFit.cover to fully cover the circle
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                  ),
                                                                )
                                                              : const Icon(
                                                                  Icons.person,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          dataoption["options"],
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    39,
                                                                    39,
                                                                    39),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  child: Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        (dataoption[
                                                                "votecount"] /
                                                            100), // Width as a percentage of screen width
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8), // Match the container's border radius
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              126,
                                                              204,
                                                              123),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text("${dataoption["votecount"]}"),
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
    );
  }
}
