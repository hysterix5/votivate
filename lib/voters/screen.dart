import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:votivate/screens/post_vote_screen.dart';
import 'package:votivate/styles/styles.dart';

class ElectionScreen extends StatefulWidget {
  final DocumentSnapshot optionData;

  const ElectionScreen(this.optionData, {super.key});

  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  late String electionId;
  late CollectionReference pollCollection;
  final _formKey = GlobalKey<FormBuilderState>();
  User? user = FirebaseAuth.instance.currentUser;
  final Map<int, Set<int>> _votedOptions = {};

  @override
  void initState() {
    super.initState();
    electionId = widget.optionData.id;
    CollectionReference electionCollection =
        FirebaseFirestore.instance.collection("active_elections");
    DocumentReference electionDoc = electionCollection.doc(electionId);
    pollCollection = electionDoc.collection("polls");
  }

  final Map<int, int?> _selectedOptionIndex = {};
  void showReviewDialog(BuildContext context, List<dynamic> pollDocuments,
      Map<int, int?> selectedOptionIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Review Votes'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(pollDocuments.length, (index) {
                final polldata = pollDocuments[index];
                Map<String, dynamic> poll = polldata["poll"];

                List<dynamic> options = poll["poll_options"];

                int? selectedIndex = selectedOptionIndex[index];
                if (selectedIndex != null) {
                  final dataoption = options[selectedIndex];
                  return ListTile(
                    title: Text(poll["poll_question"],
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                    subtitle: Text(dataoption["options"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  );
                }
                return const SizedBox.shrink(); // Hide if no option is selected
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the review dialog
              },
              child: const Text(
                  'Back'), // Allow users to go back and edit selections
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Submitting Votes'),
                      content: FutureBuilder<void>(
                        future:
                            _submitVotes(pollDocuments, selectedOptionIndex),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'An error occurred while submitting votes: ${snapshot.error}',
                            );
                          } else {
                            // If submission is successful, navigate to the next screen
                            Future.delayed(Duration.zero, () {});
                            return const SizedBox
                                .shrink(); // Return an empty container
                          }
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text('Submit'), // Finalize and submit votes
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitVotes(
      List<dynamic> pollDocuments, Map<int, int?> selectedOptionIndex) async {
    final participate = Provider.of<DataProvider>(context, listen: false);
    final vote = Provider.of<DataProvider>(context, listen: false);
    Map<String, dynamic> userVotes = {};
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final program = userSnapshot['program'];

    for (int index = 0; index < pollDocuments.length; index++) {
      final indexSelectedOption = selectedOptionIndex[index];
      if (indexSelectedOption != null) {
        final polldata = pollDocuments[index];
        Map<String, dynamic> poll = polldata["poll"];

        List<dynamic> options = poll["poll_options"];
        final dataoption = options[indexSelectedOption];

        await vote.voteFunction(
          electionId: electionId,
          electionData: polldata,
          previousTotalVotes: poll["voter_count"],
          selectedOptions: dataoption["options"],
          voterProgram: program,
        );

        // Get the poll question
        String pollQuestion = poll["poll_question"];

        // Add the selected option to userVotes with the poll question as the key
        userVotes[pollQuestion] = dataoption["options"];
      }
    }

    // Add participant and their votes
    participate.addParticipant(
      electionId: electionId,
      votes: userVotes,
      voterProgram: program,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: ((context) => const PostVote()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          'Election Screen',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.bgColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pollCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          var pollDocuments = snapshot.data!.docs;

          return SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: List.generate(pollDocuments.length, (index) {
                          final polldata = pollDocuments[index];
                          Map<String, dynamic> poll = polldata["poll"];

                          List<dynamic> options = poll["poll_options"];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.bgColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    poll["poll_question"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: AppColors.bgColor,
                                    ),
                                  ),
                                ),
                                ...List.generate(options.length, (optionindex) {
                                  final dataoption = options[optionindex];
                                  if (!_votedOptions.containsKey(index)) {
                                    _votedOptions[index] = {};
                                  }

                                  return Consumer<DataProvider>(
                                    builder: (context, vote, child) {
                                      return RadioListTile<int>(
                                        title: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (dataoption['image'] !=
                                                    null) {
                                                  // Show full-size image in a dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        child: SizedBox(
                                                          height:
                                                              300, // Adjust the height as per your requirement
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    dataoption[
                                                                        'image']),
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
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Image Not Available'),
                                                        content: const Text(
                                                            'Sorry, the image is not available.'),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
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
                                                    Colors.transparent,
                                                child: dataoption['image'] !=
                                                        null
                                                    ? ClipOval(
                                                        child: Image.network(
                                                          dataoption['image'],
                                                          fit: BoxFit
                                                              .cover, // Use BoxFit.cover to fully cover the circle
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.person,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              dataoption["options"],
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: optionindex,
                                        groupValue: _selectedOptionIndex[index],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedOptionIndex[index] =
                                                value!; // Update the selected index
                                          });
                                          // Add your logic here when an option is selected
                                        },
                                        activeColor: AppColors
                                            .bgColor, // Change the selected radio button color
                                        controlAffinity: ListTileControlAffinity
                                            .trailing, // Align the radio button to the right
                                        dense:
                                            true, // Reduce the height of the tile
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                                horizontal:
                                                    8.0), // Adjust padding
                                        selected: _selectedOptionIndex[index] ==
                                            optionindex, // Highlight the selected tile
                                      );
                                    },
                                  );
                                })
                              ],
                            ),
                          );
                        }),
                      )),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          bool allVotesSelected = true;
                          for (int index = 0;
                              index < pollDocuments.length;
                              index++) {
                            if (_selectedOptionIndex[index] == null) {
                              allVotesSelected = false;
                              break;
                            }
                          }

                          if (allVotesSelected) {
                            showReviewDialog(
                                context, pollDocuments, _selectedOptionIndex);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text("Please fill all forms"),
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
                          backgroundColor: AppColors
                              .accentColor, // Change the button's background color
                          // You can also modify other properties like textStyle, padding, elevation, etc.
                        ),
                        child: Text('Submit',
                            style: TextStyle(
                              color: AppColors.white,
                            )),
                      )),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
