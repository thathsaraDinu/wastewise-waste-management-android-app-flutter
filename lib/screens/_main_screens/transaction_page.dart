import 'dart:async'; // Import to use Timer
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:waste_wise/screens/transactions/transaction_details.dart';

class TransactionMain extends StatefulWidget {
  const TransactionMain({super.key});

  @override
  State<TransactionMain> createState() => _TransactionMainState();
}

class _TransactionMainState extends State<TransactionMain> {
  final FirebaseTransactions _firebaseTransactions = FirebaseTransactions();

  String searchQuery = '';
  String sortOption = "Recent";
  bool isLoading = false; // Loading state
  List<TransactionsModel> allTransactions = []; // To hold all transactions
  List<TransactionsModel> filteredTransactions =
      []; // To hold filtered transactions
  Timer? debounce; // Timer for debounce functionality

  // Fetching transactions
  Future<List<TransactionsModel>> _fetchTransactions() async {
    return await _firebaseTransactions.fetchTransactions();
  }

  // Function to filter and sort transactions
  void _filterAndSortTransactions() {
    setState(() {
      // Start loading when filtering
      isLoading = true;
    });

    // Filter by search query
    filteredTransactions = allTransactions.where((transaction) {
      return transaction.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          transaction.transactionId
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();

    // Sort the filtered data
    switch (sortOption) {
      case "Recent":
        filteredTransactions
            .sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
        break;
      case "Oldest":
        filteredTransactions
            .sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
        break;
      case "Amount":
        filteredTransactions.sort((a, b) => b.value.compareTo(a.value));
        break;
    }

    // Stop loading
    setState(() {
      isLoading = false; // Stop loading after sorting
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions().then((transactions) {
      setState(() {
        allTransactions = transactions; // Save all transactions
        filteredTransactions = transactions; // Initialize filtered transactions
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Custom Header Section with Background Image
          Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: 210, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/vehicle.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 80, 87, 80).withOpacity(0.6),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
              // Overlaying the Title and Search
              Positioned(
                top: MediaQuery.of(context)
                    .padding
                    .top, // Start after status bar
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Transaction History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        onChanged: (value) {
                          // Debounce the search input
                          if (debounce?.isActive ?? false) debounce!.cancel();
                          debounce =
                              Timer(const Duration(milliseconds: 300), () {
                            setState(() {
                              searchQuery = value; // Update search query
                            });
                            _filterAndSortTransactions(); // Call filtering and sorting
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search by title or transaction ID",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Total Transactions and Sort Option below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Transactions on the left
                Text(
                  "Total Transactions: ${filteredTransactions.length}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                // Sort Dropdown on the right
                DropdownButton<String>(
                  value: sortOption,
                  dropdownColor: Colors.white,
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
                      _filterAndSortTransactions(); // Re-filter and sort when sorting option changes
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Loading spinner below the image when sorting
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            ),

          // History List
          Expanded(
            child: filteredTransactions.isNotEmpty
                ? ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      var transaction = filteredTransactions[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailPage(
                                transaction: transaction,
                              ),
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
                              child: Row(
                                children: [
                                  // Payment Icon
                                  Icon(
                                    Icons.payment,
                                    size: 60, // Adjust icon size as needed
                                    color: Colors.green[600],
                                  ),
                                  const SizedBox(
                                      width: 16), // Space between icon and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Combine name and status in a Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                transaction.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Status displayed on the same line
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: transaction.status ==
                                                        'completed'
                                                    ? Colors.green
                                                    : transaction.status ==
                                                            'pending'
                                                        ? Colors.orange
                                                        : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                transaction.status
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // ...

                                        Row(
                                          children: [
                                            const Icon(Icons.date_range),
                                            const SizedBox(width: 4),
                                            Text(transaction.timestamp
                                                .toString()
                                                .split(' ')[0]), // Date
                                            const SizedBox(
                                                width:
                                                    32), // Space between date and value
                                            const Icon(Icons.attach_money),
                                            const SizedBox(width: 4),
                                            Text(
                                                "LKR. ${transaction.value.toStringAsFixed(2)}"), // Value
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.assignment),
                                            const SizedBox(width: 4),
                                            Text(transaction.transactionId),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : const Center(child: Text('No transactions available')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    debounce?.cancel(); // Cancel debounce timer on dispose
    super.dispose();
  }
}
