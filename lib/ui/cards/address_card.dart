import 'package:flutter/material.dart';

class AddressCard extends StatefulWidget {
  const AddressCard({
    super.key,
  });

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  // Initial address and contact information
  String _address = "216 St Paul's Rd, Malabe, Sri Lanka";
  String _contact = "+44-784232";

  // Function to open the dialog for editing address
  Future<void> _editAddress() async {
    final _addressController = TextEditingController(text: _address);
    final _contactController = TextEditingController(text: _contact);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Address input field
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 10),
              // Contact input field
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _address = _addressController.text;
                  _contact = _contactController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.location_on, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _address,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "Contact : $_contact",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: _editAddress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
