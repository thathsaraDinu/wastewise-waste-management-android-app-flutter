import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart'; // Assuming this contains your TransactionsModel

class TransactionMain extends StatefulWidget {
  const TransactionMain({super.key});

  @override
  State<TransactionMain> createState() => _TransactionMainState();
}

class _TransactionMainState extends State<TransactionMain> {
  final FirebaseTransactions _firebaseTransactions = FirebaseTransactions();

  String searchQuery = '';
  String sortOption = "Recent";

  // Fetching transactions
  Future<List<TransactionsModel>> _fetchTransactions() async {
    return await _firebaseTransactions.fetchTransactions();
  }

  // Function to filter and sort transactions
  List<TransactionsModel> _filterAndSortTransactions(
      List<TransactionsModel> transactions) {
    List<TransactionsModel> filteredData = transactions;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredData = filteredData
          .where((transaction) =>
              transaction.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              transaction.transactionId
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Sort the filtered data
    switch (sortOption) {
      case "Recent":
        filteredData.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
        break;
      case "Oldest":
        filteredData.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
        break;
      case "Amount":
        filteredData.sort((a, b) => b.value.compareTo(a.value));
        break;
    }

    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.green[600],
      ),
      body: FutureBuilder<List<TransactionsModel>>(
        future: _fetchTransactions(),
        builder: (context, snapshot) {
          // Display loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If data is fetched successfully
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<TransactionsModel> transactions = snapshot.data!;

            // Filter and sort transactions
            List<TransactionsModel> filteredTransactions =
                _filterAndSortTransactions(transactions);

            // Display filtered and sorted transactions
            return Column(
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
                      hintText: "Search by title or transaction ID",
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
                    items: <String>['Recent', 'Oldest', 'Amount']
                        .map((String value) {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        var transaction = filteredTransactions[index];

                        return GestureDetector(
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
                                      transaction.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Date: ${transaction.timestamp.toString().split(' ')[0]}"),
                                        Text(
                                            "Amount: \$${transaction.value.toStringAsFixed(2)}"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text("Status: "),
                                        Text(
                                          transaction.status,
                                          style: TextStyle(
                                            color: transaction.status ==
                                                    'Completed'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        "Transaction ID: ${transaction.transactionId}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }

          // Show message when there are no transactions
          return const Center(child: Text('No transactions available'));
        },
      ),
    );
  }
}
