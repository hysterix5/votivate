import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:math';

class CreateElectionSuper extends StatefulWidget {
  const CreateElectionSuper({super.key});

  @override
  State<CreateElectionSuper> createState() => _CreateElectionSuperState();
}

class _CreateElectionSuperState extends State<CreateElectionSuper> {
  User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _electionNameController = TextEditingController();
  String selectedValue = 'BSIT';

  String generateElectionCode(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
  }

  bool _uploading = false;
  String? imageURL;
  File? temporaryImage;
  File? pickedImage;

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = referenceRoot.child('logo');
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    Reference referenceUpload = referenceDir.child(fileName);

    try {
      setState(() {
        _uploading = true; // Set uploading to true when starting upload
      });

      await referenceUpload.putFile(imageFile);

      setState(() {
        _uploading = false; // Set uploading to false when upload is complete
      });

      final imageURL = await referenceUpload.getDownloadURL();
      print("Image uploaded to Firebase Storage. URL: $imageURL");
      return imageURL;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      setState(() {
        _uploading = false; // Set uploading to false on error
      });
      return null;
    }
  }

  void showUploadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Please wait..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  late String generatedPassword;
  @override
  void initState() {
    super.initState();
    generatedPassword =
        generateElectionCode(5); // Initialize generatedPassword in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/votivate.png',
              height: 30.0, // Adjust the height as needed
              width: 30.0, // Adjust the width as needed
              // Add other properties like alignment if needed
            ),
            const SizedBox(
                width: 8), // Add some space between the logo and text
            const Text(
              "Create Election",
              style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 13, 131, 2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 211, 208, 208),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _electionNameController,
                decoration: const InputDecoration(
                  labelText: 'Election Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the election name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(
                  labelText: 'Select Program', // Add label text
                  border: OutlineInputBorder(
                    // Add border styling
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  // You can add more styling here as needed
                ),
                items: <String>['BSIT', 'BSBA', 'BSED', 'BEED', 'BSSW', 'BSHM']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              if (pickedImage != null)
                GestureDetector(
                  onTap: () async {
                    final file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (file == null) return;

                    setState(() {
                      pickedImage =
                          File(file.path); // Set pickedImage to display
                      temporaryImage =
                          pickedImage; // Store pickedImage temporarily
                    });
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.file(
                      pickedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              const SizedBox(width: 10.0),
              if (pickedImage == null)
                IconButton(
                  onPressed: () async {
                    final file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (file == null) return;

                    setState(() {
                      pickedImage =
                          File(file.path); // Set pickedImage to display
                      temporaryImage =
                          pickedImage; // Store pickedImage temporarily
                    });
                  },
                  icon: const Icon(Icons.photo_camera), // Icon for image picker
                ),
              const Text("Set Logo here"),
              const SizedBox(height: 10.0),
              const Divider(
                  height: 1.0,
                  thickness: 1,
                  color: Color.fromARGB(255, 75, 75, 75)),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String electionName = _electionNameController.text.trim();
                    CollectionReference electionCollection = FirebaseFirestore
                        .instance
                        .collection("pending_elections");
                    var querySnapshot = await electionCollection
                        .where('name', isEqualTo: electionName)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      _electionNameController.clear();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text("Election Already Exists!"),
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
                    } else {
                      showUploadingDialog();
                      if (pickedImage != null) {
                        imageURL =
                            await uploadImageToFirebaseStorage(pickedImage!);
                      }

                      electionCollection.add({
                        'name': electionName,
                        'program': selectedValue,
                        'author': user?.displayName,
                        'author_id': user?.uid,
                        'pass_code': generatedPassword,
                        'date_created': DateTime.now(),
                        'logo': imageURL,
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 122, 4),
                ),
                child: const Text(
                  'Set Election Name',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
