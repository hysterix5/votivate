//fetch poll data from firebase then display into user UI

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class FetchUserProvider extends ChangeNotifier {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> updateAccessLevel({
    required String userId,
    required int setAccessLevel,
  }) async {
    try {
      DocumentReference userDoc = usersCollection.doc(userId);

      final data = {"access_level": setAccessLevel};

      await userDoc.update(data);
    } catch (e) {
      print("Error updating election: $e");
    }
  }

  void deleteUser({
    required String userId,
  }) async {
    try {
      DocumentReference usersDoc = usersCollection.doc(userId);

      await usersDoc.delete();
    } catch (e) {
      print("error");
    }
  }
}
