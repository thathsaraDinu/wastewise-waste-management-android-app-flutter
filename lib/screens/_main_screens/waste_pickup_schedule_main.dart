import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_wise/screens/waste_pickup_schedule/waste_pickup_schedule_form.dart';
import 'package:waste_wise/screens/waste_pickup_schedule/waste_pickup_schedule_details.dart';

class WastePickupScheduleMain extends StatefulWidget {
  const WastePickupScheduleMain({super.key});

  @override
  State<WastePickupScheduleMain> createState() =>
      _WastePickupScheduleMainState();
}

class _WastePickupScheduleMainState extends State<WastePickupScheduleMain> {
  // Function to delete a pickup request
  Future<void> _deletePickup(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('waste_pickups')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup schedule canceled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel pickup schedule')),
      );
    }
  }

  // Function to show confirmation dialog
  Future<void> _confirmDelete(String documentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content:
            const Text('Are you sure you want to cancel this pickup schedule?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text(
              'No',
              style: TextStyle(color: Colors.green[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              _deletePickup(documentId); // Proceed with deletion
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.green[600]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WastePickupScheduleForm()),
          );
        },
        backgroundColor: Colors.green[600],
        shape: const CircleBorder(),
        elevation: 6.0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
                            "Hi, Nipun",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Welcome",
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
              'My Waste Pickup Schedules',
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton.icon(
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
                                        icon: Icon(Icons.info,
                                            color: Colors.green[600]),
                                        label: Text(
                                          "Details",
                                          style: TextStyle(
                                              color: Colors.green[600]),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Colors.green.shade600,
                                              width: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          _confirmDelete(documentId);
                                        },
                                        icon: const Icon(Icons.cancel,
                                            color: Colors.red),
                                        label: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.red, width: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    ],
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
