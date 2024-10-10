import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_wise/screens/vendor_screens/waste_pickup_schedule_details.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';

class AcceptedPickups extends StatelessWidget {
  const AcceptedPickups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Accepted Pickups'),
          backgroundColor: Colors.green[600],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('waste_pickups')
              .where('status', isEqualTo: 'accepted') // Filter accepted pickups
              .orderBy('timestamp', descending: true) // Order by most recent
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var acceptedPickups = snapshot.data!.docs;

            if (acceptedPickups.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping, size: 80, color: Colors.green),
                    SizedBox(height: 20),
                    Text(
                      'No Accepted Pickups Yet!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'All your accepted pickups will show up here.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: acceptedPickups.length,
              itemBuilder: (context, index) {
                var pickup = acceptedPickups[index];
                String documentId = pickup.id; // Document ID

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border:
                          Border.all(color: Colors.green.shade600, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Accepted Pickup",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                                style: const TextStyle(color: Colors.black),
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
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Navigate to details page
                                var pickupData =
                                    pickup.data() as Map<String, dynamic>?;
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
                                  // Handle case where pickup data is null
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Pickup details are missing')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.info_outline,
                                  color: Colors.black),
                              label: const Text(
                                "View Details",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 50, 84, 52),
                                    width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 98, 212, 96),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
