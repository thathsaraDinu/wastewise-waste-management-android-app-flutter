// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for changing the system UI
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_wise/screens/vendor_screens/accept_waste_details.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  @override
  Widget build(BuildContext context) {
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.dark, // White icons for dark status bar
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(23, 130, 129, 129),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/vendortruck.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 68, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hi Eshan,",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Manage your Waste pickups",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      fillColor: Color.fromARGB(173, 255, 255, 255),
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text(
              'MY PICKUP REQUESTS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('waste_pickups')
                  // Temporarily remove this filter to test the query
                  //.where('status', isNotEqualTo: 'accepted')
                  .orderBy('timestamp', descending: true) // Order by timestamp
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var pickupData = snapshot.data!.docs;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(
                      pickupData.length,
                      (index) {
                        var pickup = pickupData[index];
                        String documentId = pickup.id; // Document ID

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              border: Border.all(
                                  color: const Color.fromARGB(105, 67, 160, 72),
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side (details)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Pickup Request",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 18, color: Colors.black),
                                          const SizedBox(width: 8),
                                          Text(
                                            pickup['scheduledDate'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.delete_outline,
                                              size: 18, color: Colors.black),
                                          const SizedBox(width: 8),
                                          Text(
                                            pickup['wasteType'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Right side (Accept Button)
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      var pickupData = pickup.data()
                                          as Map<String, dynamic>?;

                                      if (pickupData != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AcceptWasteDetails(
                                                    pickup: pickupData,
                                                    documentId: pickup.id),
                                          ),
                                        );
                                      } else {
                                        // Handle the case where pickupData is null
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Pickup details are missing')),
                                        );
                                      }
                                    }, // Change the icon
                                    label: const Text(
                                      "ACCEPT",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 251, 255, 251),
                                          width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 115, 238, 113),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
