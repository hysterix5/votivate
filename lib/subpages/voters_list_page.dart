import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class VotersList extends StatefulWidget {
  final DocumentSnapshot data;

  const VotersList(this.data, {super.key});

  @override
  _VotersListState createState() => _VotersListState();
}

class _VotersListState extends State<VotersList> {
  late String electionId;
  late CollectionReference pollCollection;
  final _formKey = GlobalKey<FormBuilderState>();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    CollectionReference electionCollection =
        FirebaseFirestore.instance.collection("election");
    DocumentReference electionDoc = electionCollection.doc(electionId);
    pollCollection = electionDoc.collection("polls");
    // Call a method to fetch data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Screen'),
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
                          List<dynamic> voters = poll["voters"];

                          return Column(
                            children: [
                              Text(voters[index]['name']),
                            ],
                          );
                        }),
                      )),
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}
