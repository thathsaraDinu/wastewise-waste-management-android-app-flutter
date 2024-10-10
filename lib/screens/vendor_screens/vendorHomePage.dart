import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_wise/screens/vendor_screens/waste_pickup_schedule_details.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the background transparent
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/vehicle.jpg"),
                    fit: BoxFit.fill)),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hi, Eshan",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Manage your pickup requests",
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
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
                        fillColor: Colors.white,
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10)),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'My Pickup Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('waste_pickups')
                  .orderBy('timestamp', descending: true)
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
                                  color: Colors.green.shade600, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Pickup Request",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 16),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.green.shade600,
                                                width: 1)),
                                        child: Text(
                                          "Scheduled",
                                          style: TextStyle(
                                            color: Colors.green.shade600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  const SizedBox(height: 8),
                                  // Accept Button on the right side
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        var pickupData = pickup.data()
                                            as Map<String, dynamic>?;

                                        if (pickupData != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WastePickupScheduleDetails(
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
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Color.fromARGB(
                                              255, 0, 0, 0)), // Change the icon
                                      label: const Text(
                                        "Accept",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0,
                                                0)), // Change the button text
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 84, 245, 92),
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 98, 212, 96),
                                      ),
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