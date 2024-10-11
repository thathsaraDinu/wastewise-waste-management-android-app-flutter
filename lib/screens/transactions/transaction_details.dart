import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class TransactionDetailPage extends StatefulWidget {
  final TransactionsModel transaction;

  const TransactionDetailPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  double _ratingValue = 0;
  TextEditingController _feedbackController = TextEditingController();

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<void> _updateTransaction() async {
    final FirebaseTransactions firebaseTransactions = FirebaseTransactions();
    try {
      var docRef = firebaseTransactions
          .getTransactionDocument(widget.transaction.transactionId);

      Map<String, dynamic> updatedData = {
        'feedback': _feedbackController.text,
        'rating': _ratingValue,
        'status': 'completed',
      };

      await docRef.update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction updated successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update transaction: $e')),
      );
    }
  }

  void _showApprovalConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Payment Approval'),
          content: const Text('Are you sure you want to approve this payment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog if "No"
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                await _approvePayment(); // Call the method to approve payment
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _approvePayment() async {
    final FirebaseTransactions firebaseTransactions = FirebaseTransactions();
    try {
      var docRef = firebaseTransactions
          .getTransactionDocument(widget.transaction.transactionId);

      Map<String, dynamic> updatedData = {
        'status': 'completed',
      };

      await docRef.update(updatedData);
      _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve payment: $e')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Automatically close the dialog after a delay
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close the dialog after 2 seconds
          // Update the UI to reflect the changed status here
          setState(() {
            widget.transaction.status =
                'completed'; // Update the transaction status
          });
        });
        return AlertDialog(
          title: const Text('Success'),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Colors.green), // Icon for success
              SizedBox(width: 8),
              Expanded(child: Text('Transaction completed!')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog immediately if the user clicks
                setState(() {
                  widget.transaction.status =
                      'completed'; // Update the transaction status
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/waste/metal.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.transaction.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "#${widget.transaction.transactionId}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "${widget.transaction.timestamp?.day ?? ''}/${widget.transaction.timestamp?.month ?? ''}/${widget.transaction.timestamp?.year ?? ''} ${widget.transaction.timestamp?.hour ?? ''}:${widget.transaction.timestamp?.minute ?? ''}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, size: 20),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.transaction.status == 'completed'
                                  ? Colors.green
                                  : widget.transaction.status == 'pending'
                                      ? Colors.orange
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.transaction.status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1.5, height: 32),
                  Row(
                    children: [
                      const Icon(Icons.money, size: 30),
                      const SizedBox(width: 8),
                      Text(
                        "LKR. ${widget.transaction.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.transaction.note.isNotEmpty) ...[
                    const Text(
                      "Note",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.transaction.note,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // If rating is not 0 or feedback is not empty, show feedback
                  if (widget.transaction.rating > 0) ...[
                    const Text(
                      "Your Feedback",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.transaction.feedback,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    RatingStars(
                      value: widget.transaction.rating,
                      valueLabelColor: Colors.amber,
                      valueLabelTextStyle: const TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      starColor: Colors.amber,
                      starCount: 5,
                      starSize: 30,
                      valueLabelRadius: 0,
                      valueLabelPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.transaction.status == 'completed' &&
                      widget.transaction.rating == 0) ...[
                    const Text(
                      "Feedback",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Leave your feedback here',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    RatingStars(
                      value: _ratingValue,
                      starSize: 50,
                      onValueChanged: (value) {
                        setState(() {
                          _ratingValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _updateTransaction,
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          "Submit Feedback",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: _buttonStyle(Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else if (widget.transaction.status == 'pending') ...[
                    const Text(
                      "Please confirm the payment after verifying the transaction.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed:
                            _showApprovalConfirmationDialog, // Call the confirmation dialog
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: const Text(
                          "Approve Payment",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: _buttonStyle(Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
