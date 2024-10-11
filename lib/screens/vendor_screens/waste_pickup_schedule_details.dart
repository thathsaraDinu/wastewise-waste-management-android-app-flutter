import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:waste_wise/screens/vendor_screens/vendorHome.dart';

class WastePickupScheduleDetails extends StatefulWidget {
  final Map<String, dynamic> pickup;
  final String documentId;

  const WastePickupScheduleDetails({
    super.key,
    required this.pickup,
    required this.documentId,
  });

  @override
  State<WastePickupScheduleDetails> createState() =>
      _WastePickupScheduleDetailsState();
}

class _WastePickupScheduleDetailsState
    extends State<WastePickupScheduleDetails> {
  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
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
                widget.pickup['scheduledDate'], // Use the pickup object here
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
                widget.pickup['wasteType'], // Use the pickup object here
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Add a button to complete the payment
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CompleteOrderDialog(
                              wasteType: widget.pickup['wasteType'],
                              documentId: widget.documentId,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.payment, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Complete Order",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // End of the button to complete the payment
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
            : const Text("No image available", style: TextStyle(fontSize: 16)));
  }
}

// Complete Order Dialog
class CompleteOrderDialog extends StatefulWidget {
  final String wasteType;
  final String documentId;

  const CompleteOrderDialog({
    Key? key,
    required this.wasteType,
    required this.documentId,
  }) : super(key: key);

  @override
  _CompleteOrderDialogState createState() => _CompleteOrderDialogState();
}
// End of the Complete Order Dialog

// Add the _showCompleteOrderDialog method
class _CompleteOrderDialogState extends State<CompleteOrderDialog> {
  final TextEditingController _pricePerKgController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double _totalCost = 0.0;
  bool _isLoading = false;

  final FirebaseTransactions _firebaseTransactions = FirebaseTransactions();

  void _calculateTotalCost() {
    final double pricePerKg = double.tryParse(_pricePerKgController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _totalCost = pricePerKg * weight;
    });
  }

  Future<void> _saveTransaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transaction = TransactionsModel(
        transactionId: widget.documentId,
        name: widget.wasteType,
        pricePerKg: double.tryParse(_pricePerKgController.text) ?? 0,
        weight: double.tryParse(_weightController.text) ?? 0,
        value: _totalCost,
        note: _noteController.text,
        requestId: widget.documentId,
        timestamp: DateTime.now(),
      );

      // Save the transaction using the FirebaseTransactions service
      await _firebaseTransactions.saveTransaction(transaction);

      // Show the success dialog with transaction data
      _showSuccessDialog(transaction);
    } catch (e) {
      // Handle error (show a snackbar or dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save transaction: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(TransactionsModel transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: const EdgeInsets.all(16.0),
          titlePadding: const EdgeInsets.only(top: 16.0),
          content: Container(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Transaction Successful",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Transaction Details
                Text(
                  "Waste Type:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Weight:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${transaction.weight} Kg",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Total Cost:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "LKR. ${transaction.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Note:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.note.isNotEmpty
                      ? transaction.note
                      : "No additional note provided",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Action Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the success dialog
                    Navigator.pop(context); // Close the CompleteOrderDialog
                    // Navigate to History page in the bottom navigation bar
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const VendorHome(selectedIndex: 2),
                      ),
                      (route) =>
                          false, // This removes all previous routes from the stack
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Go to History",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Complete Order for ${widget.wasteType}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 16),
            // Price per Kg
            TextField(
              controller: _pricePerKgController,
              decoration: InputDecoration(
                labelText: 'Price per Kg',
                border: const OutlineInputBorder(),
                errorText:
                    _priceError.isEmpty ? null : _priceError, // Display error
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                _calculateTotalCost();
                _validatePrice();
              },
            ),
            const SizedBox(height: 16),
            // Weight (Kg)
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (Kg)',
                border: const OutlineInputBorder(),
                errorText:
                    _weightError.isEmpty ? null : _weightError, // Display error
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) {
                _calculateTotalCost();
                _validateWeight();
              },
            ),
            const SizedBox(height: 16),
            // Note
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Total Cost: LKR. $_totalCost",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _validateForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

// Validation logic
  String _priceError = '';
  String _weightError = '';

  void _validatePrice() {
    final price = double.tryParse(_pricePerKgController.text);
    if (price == null || price <= 0) {
      _priceError = 'Please enter a valid price greater than 0';
    } else {
      _priceError = '';
    }
  }

  void _validateWeight() {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      _weightError = 'Please enter a valid weight greater than 0';
    } else {
      _weightError = '';
    }
  }

  void _validateForm() {
    _validatePrice();
    _validateWeight();

    if (_priceError.isEmpty && _weightError.isEmpty) {
      _saveTransaction();
    } else {
      // Show an alert or any other indication of validation failure
      setState(() {}); // Trigger rebuild to show errors
    }
  }

  @override
  void dispose() {
    _pricePerKgController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
