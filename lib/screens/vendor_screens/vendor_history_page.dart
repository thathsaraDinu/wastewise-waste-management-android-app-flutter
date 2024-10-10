import 'package:flutter/material.dart';
import '../history/transaction_details.dart'; // Import the TransactionDetails widget

class VendorHistoryPage extends StatefulWidget {
  const VendorHistoryPage({Key? key}) : super(key: key);

  @override
  State<VendorHistoryPage> createState() => _VendorHistoryPageState();
}

class _VendorHistoryPageState extends State<VendorHistoryPage> {
  final List<Map<String, dynamic>> historyData = [
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 9, 1),
      "amount": 25.00,
      "status": "Completed",
      "transactionId": "TXN12345",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 8, 25),
      "amount": 15.00,
      "status": "Completed",
      "transactionId": "TXN12346",
    },
    {
      "title": "Waste Disposal",
      "date": DateTime(2024, 8, 20),
      "amount": 30.00,
      "status": "Pending",
      "transactionId": "TXN12347",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 8, 15),
      "amount": 40.00,
      "status": "Completed",
      "transactionId": "TXN12348",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 7, 30),
      "amount": 50.00,
      "status": "Completed",
      "transactionId": "TXN12349",
    },
    {
      "title": "Waste Disposal",
      "date": DateTime(2024, 7, 20),
      "amount": 20.00,
      "status": "Completed",
      "transactionId": "TXN12350",
    },
    {
      "title": "Waste Collection",
      "date": DateTime(2024, 6, 15),
      "amount": 60.00,
      "status": "Pending",
      "transactionId": "TXN12351",
    },
  ];

  String searchQuery = '';
  String sortOption = "Recent";

  // This function filters and sorts the history items based on the current state
  List<Map<String, dynamic>> get filteredHistoryData {
    List<Map<String, dynamic>> filteredData = historyData;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredData = filteredData
          .where((item) =>
              item['title']!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              item['transactionId']!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Sort the filtered data
    switch (sortOption) {
      case "Recent":
        filteredData.sort((a, b) => b['date'].compareTo(a['date']));
        break;
      case "Oldest":
        filteredData.sort((a, b) => a['date'].compareTo(b['date']));
        break;
      case "Amount":
        filteredData.sort((a, b) => b['amount'].compareTo(a['amount']));
        break;
    }

    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              items: <String>['Recent', 'Oldest', 'Amount'].map((String value) {
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
                itemCount: filteredHistoryData.length,
                itemBuilder: (context, index) {
                  var historyItem = filteredHistoryData[index];

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
                                  Text("Amount: \$${historyItem['amount']}"),
                                ],
                              ),
                              const SizedBox(height: 8),
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
                                  "Transaction ID: ${historyItem['transactionId']}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
