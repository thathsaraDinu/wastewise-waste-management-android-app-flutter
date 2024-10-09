import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TransactionDetails extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetails({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  double _rating = 0;
  String _feedbackText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.green[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.transaction['title']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
                'Date: ${widget.transaction['date'].toString().split(' ')[0]}'),
            Text('Amount: \$${widget.transaction['amount']}'),
            Text('Status: ${widget.transaction['status']}'),
            Text('Transaction ID: ${widget.transaction['transactionId']}'),
            const SizedBox(height: 20),
            const Text(
              'Give Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.0,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
                hintText: 'Write your feedback here...',
              ),
              onChanged: (value) {
                setState(() {
                  _feedbackText = value;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _rating > 0 && _feedbackText.isNotEmpty
                  ? () {
                      // Handle feedback submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Feedback submitted: $_rating stars\nFeedback: $_feedbackText'),
                        ),
                      );
                      // Implement actual feedback submission logic here
                    }
                  : null, // Disable the button if rating or feedback is empty
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
