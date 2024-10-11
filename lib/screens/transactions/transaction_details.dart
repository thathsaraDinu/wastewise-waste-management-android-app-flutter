import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionsModel transaction;

  const TransactionDetailPage({Key? key, required this.transaction})
      : super(key: key);

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
              transaction.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text("Date: ${transaction.timestamp.toString().split(' ')[0]}"),
            const SizedBox(height: 8),
            Text("Amount: \$${transaction.value.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Status: "),
                Text(
                  transaction.status,
                  style: TextStyle(
                    color: transaction.status == 'Completed'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Transaction ID: ${transaction.transactionId}"),
            // You can add more details here
          ],
        ),
      ),
    );
  }
}
