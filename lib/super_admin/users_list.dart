import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:votivate/provider/user_provider.dart';
import 'package:votivate/styles/styles.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late CollectionReference<Map<String, dynamic>> usersRef;
  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;
  String _selectedProgram = 'BSIT';
  int _accessLevel = 1;
  int _setAccessLevel = 1;
  Map<int, String> accessLevelText = {
    1: 'Voter',
    2: 'Admin',
    3: 'Super Admin',
  };
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usersRef = FirebaseFirestore.instance.collection('users');
    userStream = usersRef.snapshots();
  }

  void searchByName() {
    setState(() {
      userStream = usersRef.orderBy('program').snapshots();
    });
  }

  void sortByName() {
    setState(() {
      userStream = usersRef.orderBy('name').snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Users",
          style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
        ),
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Sort By Program',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedProgram,
                          hint: const Text('Select Program'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProgram = newValue ?? '';
                            });
                          },
                          items: <String>[
                            'BSIT',
                            'BSBA',
                            'BSSW',
                            'BSED',
                            'BEED',
                            'BSHM',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 15),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Access Level',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<int>(
                          value: _accessLevel,
                          hint: const Text('Access Level'),
                          onChanged: (int? newValue) {
                            setState(() {
                              _accessLevel = newValue ?? 1;
                            });
                          },
                          items: accessLevelText.keys
                              .toList()
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(accessLevelText[value]!),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (_selectedProgram.isNotEmpty) {
                            setState(() {
                              userStream = usersRef
                                  .where('program', isEqualTo: _selectedProgram)
                                  .where('access_level',
                                      isEqualTo: _accessLevel)
                                  .snapshots();
                            });
                          }
                        },
                        child: const Text("Enter",
                            style: TextStyle(color: Colors.green)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: TextFormField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'Search by Name',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid value';
                          }
                          return null;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (_userNameController.text.isNotEmpty) {
                              setState(() {
                                String searchTerm =
                                    _userNameController.text.trim();

                                userStream = usersRef
                                    .where('name', isEqualTo: searchTerm)
                                    .snapshots();
                              });
                            }
                          },
                          child: const Text("Enter"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              }),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: sortByName,
          ),
        ],
      ),

      //main body
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final documents = snapshot.data?.docs ?? [];
          documents.sort(
              (a, b) => a['name'].toString().compareTo(b['name'].toString()));

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final dataId = documents[index].id;
              final data = documents[index].data();
              int accessLevel = data['access_level'];
              String accessText = '';
              if (accessLevel == 1) {
                accessText = 'Voter';
              } else if (accessLevel == 2) {
                accessText = 'Admin';
              } else if (accessLevel == 3) {
                accessText = 'Super Admin';
              } else {
                accessText = 'Unknown';
              }
              return ListTile(
                title: Text(
                  data['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 87, 3),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            data['program'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 59, 125, 224),
                            ),
                          ),
                        ),
                        Text(accessText),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 51, 109, 235), // Blue color for the box
                        borderRadius:
                            BorderRadius.circular(5.0), // Rounded corners
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.white), // Edit button icon
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Set Access Level', // Your label text
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    DropdownButtonFormField<int>(
                                      value: _setAccessLevel,
                                      hint: const Text('Set Access Level'),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          _setAccessLevel = newValue ?? 1;
                                        });
                                      },
                                      items: accessLevelText.keys
                                          .toList()
                                          .map<DropdownMenuItem<int>>(
                                              (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(accessLevelText[value]!),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        showCancelBtn: true,
                                        title: "Confirmation",
                                        text:
                                            "Are you sure you want to set this access level for '${data['name']}'?",
                                        confirmBtnText: 'Yes',
                                        cancelBtnText: 'No',
                                        confirmBtnColor: Colors.blue,
                                        onConfirmBtnTap: () {
                                          var userProvider =
                                              Provider.of<FetchUserProvider>(
                                                  context,
                                                  listen: false);
                                          userProvider.updateAccessLevel(
                                              userId: dataId,
                                              setAccessLevel: _setAccessLevel);
                                        },
                                      );
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: const Text("Confirm"),
                                      //       content: Text(
                                      //           "Are you sure you want to set this access level for '${data['name']}'"),
                                      //       actions: <Widget>[
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             var userProvider = Provider
                                      //                 .of<FetchUserProvider>(
                                      //                     context,
                                      //                     listen: false);
                                      //             userProvider
                                      //                 .updateAccessLevel(
                                      //                     userId: dataId,
                                      //                     setAccessLevel:
                                      //                         _setAccessLevel);
                                      //             Navigator.of(context)
                                      //                 .pop(); // Close the current dialog

                                      //             showDialog(
                                      //               context: context,
                                      //               builder:
                                      //                   (BuildContext context) {
                                      //                 return AlertDialog(
                                      //                   content: const Text(
                                      //                       "Access Level set successfully"),
                                      //                   actions: <Widget>[
                                      //                     TextButton(
                                      //                       onPressed: () {
                                      //                         Navigator.of(
                                      //                                 context)
                                      //                             .pop();
                                      //                       },
                                      //                       child: const Text(
                                      //                           "Ok"),
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //           },
                                      //           child: const Text("Yes"),
                                      //         ),
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             Navigator.of(context)
                                      //                 .pop(); // Close the current dialog
                                      //           },
                                      //           child: const Text("No"),
                                      //         ),
                                      //       ],
                                      //     );
                                      //   },
                                      // );
                                    },
                                    child: const Text("Enter"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 204, 14, 0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            showCancelBtn: true,
                            title: "Confirm delete",
                            text:
                                "Are you sure to delete user '${data['name']}'?",
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () {
                              var userProvider = Provider.of<FetchUserProvider>(
                                  context,
                                  listen: false);
                              userProvider.deleteUser(
                                userId: dataId,
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
