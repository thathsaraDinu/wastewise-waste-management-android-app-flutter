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

            // Show the message if there are no accepted pickups
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

            // Otherwise, show the list of accepted pickups
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
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

                          // Row for Decline and View Details Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Decline Button (left side)
                              OutlinedButton.icon(
                                onPressed: () {
                                  _showDeclineConfirmationDialog(
                                      context, pickup, documentId);
                                },
                                label: const Text(
                                  "Decline",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color.fromARGB(0, 244, 67, 54),
                                      width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(210, 182, 35, 25),
                                ),
                              ),

                              // View Details Button (right side)
                              OutlinedButton.icon(
                                onPressed: () {
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Pickup details are missing')),
                                    );
                                  }
                                },
                                label: const Text(
                                  "View Details",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color.fromARGB(0, 76, 175, 79),
                                      width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 118, 255, 123),
                                ),
                              ),
                            ],
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

  /// Function to show a confirmation dialog for declining a pickup request
  void _showDeclineConfirmationDialog(
      BuildContext context, QueryDocumentSnapshot pickup, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Decline'),
          content: const Text(
              'Are you sure you want to decline this pickup request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await _declinePickup(
                    context, pickup, documentId); // Call the decline method
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  /// Function to decline a pickup request by updating the `status` field in Firestore
  Future<void> _declinePickup(BuildContext context,
      QueryDocumentSnapshot pickup, String documentId) async {
    try {
      // Reset the status to the previous one or "pending"
      await FirebaseFirestore.instance
          .collection('waste_pickups')
          .doc(documentId)
          .update({
        'status': 'pending', // Reset to previous status
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup request declined.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error declining request: $e')),
      );
    }
  }
}
