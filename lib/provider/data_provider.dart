import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  CollectionReference electionCollection =
      FirebaseFirestore.instance.collection("active_elections");
  CollectionReference pendingElectionCollection =
      FirebaseFirestore.instance.collection("pending_elections");

  User? user = FirebaseAuth.instance.currentUser;

  //add poll to election function
  Future<void> updateElection({
    required String electionId,
    required List<Map> options,
    required String question,
  }) async {
    try {
      DocumentReference electionDoc = pendingElectionCollection.doc(electionId);
      CollectionReference pollReference = electionDoc.collection("polls");
      final data = {
        "poll": {
          "poll_options": options,
          "poll_question": question,
          "voter_count": 0,
          "voters": [],
        },
      };

      await pollReference.add(data);
    } catch (e) {
      print("Error updating election: $e");
    }
  }

  Future<void> addParticipant(
      {required String electionId,
      required Map<String, dynamic>? votes,
      required String voterProgram}) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference electionRef = FirebaseFirestore.instance
            .collection('active_elections')
            .doc(electionId);

        DocumentSnapshot electionSnapshot = await transaction.get(electionRef);

        // Get the list of participants from the document
        List<dynamic> participants =
            List.from(electionSnapshot['participants']);

        // Add the new participant data to the list
        participants.add({
          "name": user!.displayName,
          "uid": user!.uid,
          "program": voterProgram,
          "votes": votes,
        });

        // Update the 'participants' field in the document with the modified list
        transaction.update(electionRef, {'participants': participants});
      });
    } catch (e) {
      print('Transaction failed: $e');
      // Handle the error appropriately
    }
  }

  //vote function
  Future<void> voteFunction({
    required String? electionId,
    required DocumentSnapshot electionData,
    required int previousTotalVotes,
    required String selectedOptions,
    required String voterProgram,
  }) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot latestSnapshot =
            await transaction.get(electionData.reference);

        List voters = List.from(latestSnapshot['poll']['voters']);

        voters.add({
          "name": user!.displayName,
          "uid": user!.uid,
          "program": voterProgram,
          "selected_option": selectedOptions,
        });

        List options = List.from(latestSnapshot["poll"]["poll_options"]);
        for (var i in options) {
          if (i["options"] == selectedOptions) {
            i["votecount"]++;
          }
        }

        final data = {
          "poll": {
            "voter_count": previousTotalVotes + 1,
            "voters": voters,
            "poll_question": latestSnapshot["poll"]["poll_question"],
            "poll_options": options,
          }
        };

        transaction.update(electionData.reference, data);
      });
    } catch (e) {
      print("Error updating election: $e");
    }
  }

  //delete function
  void deletePoll({
    required String electionId,
    required String pollId,
  }) async {
    try {
      DocumentReference electionDoc = pendingElectionCollection.doc(electionId);
      CollectionReference pollReference = electionDoc.collection("polls");
      DocumentReference pollDoc = pollReference.doc(pollId);

      await pollDoc.delete();
    } catch (e) {
      print("error");
    }
  }

  void deleteElection({
    required String electionId,
  }) async {
    try {
      DocumentReference electionDoc = pendingElectionCollection.doc(electionId);

      // Get all subcollections of the election document
      CollectionReference pollsCollection = electionDoc.collection("polls");

      // Get all documents in the "polls" subcollection
      QuerySnapshot pollDocs = await pollsCollection.get();

      // Delete all documents in the "polls" subcollection
      for (var doc in pollDocs.docs) {
        await doc.reference.delete();
      }

      // Finally, delete the main election document
      await electionDoc.delete();
    } catch (e) {
      print("Error deleting election: $e");
    }
  }

  Future<void> endElection({required String electionId}) async {
    try {
      DocumentSnapshot<Object?> electionDocument =
          await electionCollection.doc(electionId).get();

      if (electionDocument.exists) {
        CollectionReference electionHistoryCollection =
            FirebaseFirestore.instance.collection("election_history");

        CollectionReference pollsCollection =
            electionDocument.reference.collection("polls");

        QuerySnapshot<Object?> pollCollectionSnapshot =
            await pollsCollection.get();

        // Create a batch for atomic writes
        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Move the election document to election_history
        batch.set(electionHistoryCollection.doc(electionId),
            electionDocument.data()!);

        // Move each poll document to election_history's subcollection
        for (var doc in pollCollectionSnapshot.docs) {
          batch.set(
              electionHistoryCollection
                  .doc(electionId)
                  .collection("polls")
                  .doc(doc.id),
              doc.data());
        }

        // Commit the batched writes
        await batch.commit();

        // Delete the original documents from electionCollection and its subcollection
        batch = FirebaseFirestore.instance.batch();
        batch.delete(electionDocument.reference);
        for (var doc in pollCollectionSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> releaseElection({required String electionId}) async {
    try {
      DocumentSnapshot<Object?> electionDocument =
          await pendingElectionCollection.doc(electionId).get();

      if (electionDocument.exists) {
        CollectionReference activeElectionCollection =
            FirebaseFirestore.instance.collection("active_elections");

        CollectionReference pollsCollection =
            electionDocument.reference.collection("polls");

        QuerySnapshot<Object?> pollCollectionSnapshot =
            await pollsCollection.get();

        // Create a batch for atomic writes
        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Move the election document to election_history
        batch.set(
            activeElectionCollection.doc(electionId), electionDocument.data()!);

        // Move each poll document to election_history's subcollection
        for (var doc in pollCollectionSnapshot.docs) {
          batch.set(
              activeElectionCollection
                  .doc(electionId)
                  .collection("polls")
                  .doc(doc.id),
              doc.data());
        }

        // Commit the batched writes
        await batch.commit();

        // Delete the original documents from electionCollection and its subcollection
        batch = FirebaseFirestore.instance.batch();
        batch.delete(electionDocument.reference);
        for (var doc in pollCollectionSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
