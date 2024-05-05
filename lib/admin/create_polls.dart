import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votivate/provider/data_provider.dart';
import 'package:image_picker/image_picker.dart';

class CreatePoll extends StatefulWidget {
  final String electionId;

  const CreatePoll(this.electionId, {super.key});

  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  List<Map<String, dynamic>> pollOptions = [];
  final TextEditingController _optionsController = TextEditingController();
  String _selectedValue = 'Executive President';
  String? imageURL;
  File? temporaryImage;
  File? pickedImage;
  bool _uploading = false;

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = referenceRoot.child('images');
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

  void updateElectionWithImageUpload() async {
    showUploadingDialog();
    List<Map<String, dynamic>> updatedOptions = [];

    for (var option in pollOptions) {
      if (option['image'] != null) {
        if (option['image'] is String) {
          // If the image is already uploaded to Firebase, just keep the URL
          updatedOptions.add(option);
        } else if (option['image'] is File) {
          File imageFile = option['image'] as File;
          String? imageURL = await uploadImageToFirebaseStorage(imageFile);

          if (imageURL != null) {
            Map<String, dynamic> updatedOption = {
              "options": option['options'],
              "votecount": option['votecount'],
              "image": imageURL, // Store the imageURL
            };
            updatedOptions.add(updatedOption);
          }
        }
      } else {
        updatedOptions.add(option);
      }
    }
    Navigator.of(context).pop();

    final dataProvider = context.read<DataProvider>();

    dataProvider.updateElection(
      electionId: widget.electionId,
      options: updatedOptions,
      question: _selectedValue,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Election poll created successfully"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Candidate",
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 2, 136, 7),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 219, 221, 219),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                        child: DropdownButtonFormField<String>(
                      value: _selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue = newValue ?? '';
                        });
                      },
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'executive_positions',
                          enabled: false,
                          child: Text(
                            'Executive Positions',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive President',
                          child: Text('Executive President'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Vice President',
                          child: Text('Executive Vice President'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Secretary',
                          child: Text('Executive Secretary'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Asst. Secretary',
                          child: Text('Executive Asst. Secretary'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Treasurer',
                          child: Text('Executive Treasurer'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive P.I.O',
                          child: Text('Executive P.I.O'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Auditor',
                          child: Text('Executive Auditor'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Business Manager',
                          child: Text('Executive Business Manager'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Executive Multimedia Manager',
                          child: Text('Executive Multimedia Manager'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'divider_1',
                          enabled: false,
                          child: Divider(),
                        ),
                        DropdownMenuItem<String>(
                          value: 'local_council_day',
                          enabled: false,
                          child: Text(
                            'Local Council (Day)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Governor (Day)',
                          child: Text('Governor (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Vice Governor (Day))',
                          child: Text('Vice Governor (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Secretary (Day)',
                          child: Text('Local Secretary (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Treasurer (Day)',
                          child: Text('Local Treasurer (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Auditor (Day)',
                          child: Text('Local Auditor (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local P.I.O. (Day)',
                          child: Text('Local P.I.O. (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'divider_2',
                          enabled: false,
                          child: Divider(),
                        ),
                        DropdownMenuItem<String>(
                          value: 'local_council_eve',
                          enabled: false,
                          child: Text(
                            'Local Council (Eve)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Governor (Eve)',
                          child: Text('Governor (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Vice Governor (Eve)',
                          child: Text('Vice Governor (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Secretary (Eve)',
                          child: Text('Local Secretary (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Treasurer (Eve)',
                          child: Text('Local Treasurer (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local Auditor (Eve)',
                          child: Text('Local Auditor (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Local P.I.O. (Eve)',
                          child: Text('Local P.I.O. (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'divider_2',
                          enabled: false,
                          child: Divider(),
                        ),
                        DropdownMenuItem<String>(
                          value: 'local_council_eve',
                          enabled: false,
                          child: Text(
                            'Class Representatives',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '1st Year Class Representative (Eve)',
                          child: Text('1st Year Class Representative (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '2nd Year Class Representative (Eve)',
                          child: Text('2nd Year Class Representative (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '3rd Year Class Representative (Eve)',
                          child: Text('3rd Year Class Representative (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '4th Year Class Representative (Eve)',
                          child: Text('4th Year Class Representative (Eve)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '1st Year Class Representative (Day)',
                          child: Text('1st Year Class Representative (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '2nd Year Class Representative (Day)',
                          child: Text('2nd Year Class Representative (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '3rd Year Class Representative (Day)',
                          child: Text('3rd Year Class Representative (Day)'),
                        ),
                        DropdownMenuItem<String>(
                          value: '4th Year Class Representative (Day)',
                          child: Text('4th Year Class Representative (Day)'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _optionsController,
                                decoration: const InputDecoration(
                                    labelText: 'Candidate/s'),
                              ),
                            ],
                          ),
                        ),
                        if (pickedImage != null)
                          GestureDetector(
                            onTap: () async {
                              final file = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              if (file == null) return;

                              setState(() {
                                pickedImage = File(
                                    file.path); // Set pickedImage to display
                                temporaryImage =
                                    pickedImage; // Store pickedImage temporarily
                              });
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.file(
                                pickedImage!,
                                fit: BoxFit.cover,
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
                                pickedImage = File(
                                    file.path); // Set pickedImage to display
                                temporaryImage =
                                    pickedImage; // Store pickedImage temporarily
                              });
                            },
                            icon: const Icon(
                                Icons.photo_camera), // Icon for image picker
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            // Check if the candidate input is not empty
                            if (_optionsController.text.isNotEmpty) {
                              File? imageFile = temporaryImage;
                              // Use temporaryImage path or empty string

                              // For demonstration purposes, adding the image to pollOptions here
                              pollOptions.add({
                                "options": _optionsController.text.trim(),
                                "votecount": 0,
                                "image":
                                    imageFile, // Store path for future upload
                              });

                              setState(() {
                                _optionsController.clear();
                                pickedImage =
                                    null; // Clear picked image after processing
                                temporaryImage =
                                    null; // Clear temporary image after processing
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 2, 134, 7),
                          ),
                          child: const Text('Add Candidate'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pollOptions.length,
                        itemBuilder: (context, index) {
                          final option = pollOptions[index];
                          final imageFile = option['image']
                              as File?; // Get the image path or use an empty string if null

                          return ListTile(
                            title: Text(option['options']),
                            leading: imageFile != null
                                ? SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 50.0,
                                  ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  pollOptions.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (pollOptions.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text("Please put at least one candidate"),
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
                updateElectionWithImageUpload();
              }
            },
            backgroundColor: const Color.fromARGB(255, 2, 122, 6),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
