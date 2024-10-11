import 'package:flutter/material.dart';
import '../history/transaction_details.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/ui/modals/payment_modal.dart';
import 'package:transaction_repository/transaction_repository.dart';

class VendorHistoryPage extends StatefulWidget {
  const VendorHistoryPage({Key? key}) : super(key: key);

  @override
  State<VendorHistoryPage> createState() => _VendorHistoryPageState();
}

class _VendorHistoryPageState extends State<VendorHistoryPage> {
  final FirebaseTransactions _firebaseTransactions =
      FirebaseTransactions(); // Create an instance of FirebaseTransactions

  final List<Map<String, dynamic>> historyData = [
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 9, 1),
      "status": "Completed",
      "requestId": "DOC12345", // Changed from transactionId to requestId
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 8, 25),
      "status": "Completed",
      "requestId": "DOC12346",
    },
    {
      "title": "Waste Disposal",
      "date": DateTime(2024, 8, 20),
      "status": "Pending",
      "requestId": "DOC12347",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 8, 15),
      "status": "Completed",
      "requestId": "DOC12348",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 7, 30),
      "status": "Completed",
      "requestId": "DOC12349",
    },
    {
      "title": "Waste Disposal",
      "date": DateTime(2024, 7, 20),
      "status": "Completed",
      "requestId": "DOC12350",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 6, 15),
      "status": "Pending",
      "requestId": "DOC12351",
    },
  ];

  String searchQuery = '';
  String sortOption = "Recent";

  // Show payment dialog with requestId
  void showPaymentDialog(String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentModal(
          requestId: requestId, // Pass requestId to the modal
          onSubmit: (double weight, double pricePerKg) =>
              submitPayment(weight, pricePerKg, requestId),
        );
      },
    );
  }

  // Submit payment and save transaction using FirebaseTransactions service
  Future<void> submitPayment(
      double weight, double pricePerKg, String requestId) async {
    final totalPrice = weight * pricePerKg;

    // Create a TransactionsModel object
    final transaction = TransactionsModel(
      transactionId: '', // Will be assigned in the Firebase service
      requestId: requestId, // Using requestId instead of transactionId
      name: 'Waste Collection', // Replace with actual name if available
      value: weight, // Assuming this represents the weight for the transaction
      note: 'Payment for waste collection', // Example note, adjust as necessary
      rating: 0.0, // Default rating, or pass a value if available
      feedback: '', // Default feedback, or pass a value if available
      pricePerKg: pricePerKg, // New line
      weight: weight, // New line
    );

    // Save to Firestore using FirebaseTransactions
    try {
      await _firebaseTransactions.saveTransaction(transaction);

      // Show success popup for 5 seconds
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Payment Successful"),
            content: Text(
                "Payment of \$${totalPrice.toStringAsFixed(2)} has been submitted successfully."),
          );
        },
      );

      // Close the success popup after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "There was an error submitting your payment. Please try again."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Vendor History'),
          backgroundColor: Colors.green[600],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by title or Document ID",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // Sort Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: sortOption,
                icon: const Icon(Icons.arrow_drop_down),
                items: <String>['Recent', 'Oldest'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sortOption = value!;
                  });
                },
              ),
            ),

            // History List
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  var historyItem = historyData[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionDetails(transaction: historyItem),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                              Text(
                                historyItem['title']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Date: ${historyItem['date'].toString().split(' ')[0]}"),
                                ],
                              ),

                              Row(
                                children: [
                                  const Text("Status: "),
                                  Text(
                                    historyItem['status']!,
                                    style: TextStyle(
                                      color:
                                          historyItem['status'] == 'Completed'
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "Document ID: ${historyItem['requestId']}"), // Changed label
                              const SizedBox(height: 16),
                              // "Do Payment" button
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
