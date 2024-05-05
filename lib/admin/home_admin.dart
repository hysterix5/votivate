import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:votivate/admin/active_elections.dart';
import 'package:votivate/admin/pending_elections.dart';
import 'package:votivate/screens/agreement.dart';
import 'package:votivate/styles/styles.dart';
import 'package:votivate/subpages/account_page.dart';
import '../screens/policy_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int activeCount = 0;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _getActiveCount();
    _getPendingCount();
  }

  Future<void> _getActiveCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('active_elections').get();

      setState(() {
        activeCount = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error getting document count: $e');
    }
  }

  Future<void> _getPendingCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('pending_elections')
              .get();

      setState(() {
        pendingCount = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error getting document count: $e');
    }
  }

  bool isLoading = false; // Flag to control loading state

  Future<void> _refresh() async {
    setState(() {
      isLoading = true; // Set loading to true before refresh
    });

    await Future.delayed(
        const Duration(seconds: 2)); // Simulating refresh delay
    await _getActiveCount();
    await _getPendingCount();
    setState(() {
      isLoading = false;
    });
  }

  List<IconData> icons = [Icons.assignment_turned_in, Icons.pending_actions];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/votivate.png',
              height: 35.0,
              width: 35.0,
            ),
            const SizedBox(width: 8),
            const Text(
              "Admin Panel",
              style: TextStyle(color: Color.fromARGB(255, 238, 240, 237)),
            ),
          ],
        ),
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: Colors.white),
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
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  List<String> pageColors = [
                    "#c75306",
                    "#07b804",
                  ];
                  List<String> pageTitles = [
                    "My Active Elections",
                    "My Pending Elections",
                  ];
                  List<String> pageContents = [
                    activeCount.toString(),
                    pendingCount.toString(),
                  ];
                  List<Widget Function()> pageNav = [
                    () => const AdminActivePage(),
                    () => const AdminPendingPage(),
                  ];

                  String colorHex =
                      index < pageColors.length ? pageColors[index] : "#FFFFFF";
                  Color cardColor = Color(
                      int.parse(colorHex.substring(1, 7), radix: 16) +
                          0xFF000000);
                  Color textColor = Colors
                      .white; // Set text color to white for better visibility on colored background

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => pageNav[index]()),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                            10.0), // Add rounded corners to the container
                      ),
                      padding: const EdgeInsets.all(
                          10.0), // Adjust padding for content spacing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pageTitles[index],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.0, // Adjust font size for the title
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              Icon(
                                icons[index],
                                color: textColor,
                                size: 36.0, // Adjust the size of the icon
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                pageContents[index],
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      52.0, // Adjust font size for the content
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40.0),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.bgColor,
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Navigate to PolicyScreen when Policy is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const PolicyScreen()),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.policy,
                        color: AppColors.bgColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Policy",
                        style: TextStyle(
                          color: AppColors.bgColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgreementPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment,
                        color: AppColors.bgColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "User Agreement",
                        style: TextStyle(
                          color: AppColors.bgColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refresh();
        },
        backgroundColor: AppColors.bgColor,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              ) // Show loading indicator
            : const Icon(
                Icons.refresh,
                color: Colors.white,
              ), // Show refresh iconicon as needed
      ),
    );
  }
}
