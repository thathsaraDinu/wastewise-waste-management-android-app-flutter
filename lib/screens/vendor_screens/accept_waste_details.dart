import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste_wise/screens/vendor_screens/vendorHomePage.dart'; // Import VendorHomePage

class AcceptWasteDetails extends StatefulWidget {
  final Map<String, dynamic> pickup;
  final String documentId;

  const AcceptWasteDetails({
    Key? key,
    required this.pickup,
    required this.documentId,
  }) : super(key: key);

  @override
  State<AcceptWasteDetails> createState() => _AcceptWasteDetailsState();
}

class _AcceptWasteDetailsState extends State<AcceptWasteDetails> {
  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  /// Function to accept a pickup request by updating the `status` field in Firestore
  Future<void> _acceptPickupRequest() async {
    try {
      // Update the Firestore document to change the status to "accepted"
      await FirebaseFirestore.instance
          .collection('waste_pickups')
          .doc(widget.documentId)
          .update({
        'status': 'accepted', // Set the status to "accepted"
      });

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Show a message confirming the acceptance
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup request accepted!')),
      );

      // Add a slight delay before navigating to VendorHomePage
      await Future.delayed(const Duration(seconds: 1));

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Navigate to VendorHomePage
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => VendorHomePage()),
      // );
    } catch (e) {
      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting request: ${e.toString()}')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Pickup'),
          content: const Text(
              'Are you sure you want to accept this pickup request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _acceptPickupRequest(); // Call the function to accept the request
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Pickup Schedule Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scheduled Pickup Date:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pickup['scheduledDate'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Waste Type:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pickup['wasteType'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pickup['address'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Phone:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.pickup['phone'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Snapshot:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              ImageDisplay(imageUrl: widget.pickup['imageUrl']),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                'Additional Details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                (widget.pickup['description'] != null &&
                        widget.pickup['description']
                            .toString()
                            .trim()
                            .isNotEmpty)
                    ? widget.pickup['description'].toString()
                    : 'No additional details provided',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Accept Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String latitude = widget.pickup['latitude'];
                        String longitude = widget.pickup['longitude'];
                        _openMap(latitude, longitude);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "View Location",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add the ImageDisplay component here
class ImageDisplay extends StatelessWidget {
  final String? imageUrl;

  const ImageDisplay({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: double.infinity, // Set width as needed
              height: 280, // Set height as needed
              fit: BoxFit.fill, // Adjusts how the image fits
            )
          : const Text("No image available", style: TextStyle(fontSize: 16)),
    );
  }
}
