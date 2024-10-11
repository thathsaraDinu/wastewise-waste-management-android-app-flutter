import 'package:flutter/material.dart';

class PaymentModal extends StatelessWidget {
  final String requestId;
  final Function(double weight, double pricePerKg) onSubmit;

  const PaymentModal({
    Key? key,
    required this.requestId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController pricePerKgController = TextEditingController();

    return AlertDialog(
      title: const Text('Enter Payment Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: weightController,
            decoration: const InputDecoration(hintText: 'Weight (kg)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: pricePerKgController,
            decoration: const InputDecoration(hintText: 'Price per kg'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            double weight = double.tryParse(weightController.text) ?? 0;
            double pricePerKg = double.tryParse(pricePerKgController.text) ?? 0;
            onSubmit(weight, pricePerKg);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
