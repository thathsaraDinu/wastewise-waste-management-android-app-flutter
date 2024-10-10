import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Variables to manage selected payment method
  String selectedPayment = 'Online Payment';
  int selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double amount = ModalRoute.of(context)!.settings.arguments as double;

    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          name: 'Checkout',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Section
              _buildOrderSummary(amount),
              const SizedBox(height: 30),

              // Payment Method Tabs
              _buildPaymentMethodTabs(),
              const SizedBox(height: 20),
              if (selectedPayment == 'Online Payment') ...[
                const Text(
                  'Select your payment method',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Increased font size
                  ),
                ),
                const SizedBox(height: 20),
                _buildCardSelection(),
                const SizedBox(height: 20),
              ],
              // Card Selection Section
              const Spacer(),

              // Confirm Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle confirm button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white), // Increased font size
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Order Summary Widget
  Widget _buildOrderSummary(double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Order', amount),
        const SizedBox(height: 10),
        _buildSummaryRow('Delivery', 0),
        const SizedBox(height: 10),
        const Divider(thickness: 1),
        _buildSummaryRow('Total', amount, isBold: true),
      ],
    );
  }

  // Reusable Row for Summary
  static Widget _buildSummaryRow(String title, double amount,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16, // Increased font size
          ),
        ),
        Text(
          '$amount',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 16, // Increased font size
          ),
        ),
      ],
    );
  }

  // Payment Method Tabs
  Widget _buildPaymentMethodTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaymentMethodTab('Online Payment'),
        const SizedBox(width: 10),
        _buildPaymentMethodTab('Cash on Delivery'),
      ],
    );
  }

  // Payment Tab Builder
  Widget _buildPaymentMethodTab(String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 25), // Adjusted padding for better fit
        decoration: BoxDecoration(
          color: selectedPayment == method ? Colors.green[300] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.green),
        ),
        child: Text(
          method,
          style: const TextStyle(fontSize: 16), // Increased font size
        ),
      ),
    );
  }

  // Card Selection Widget
  Widget _buildCardSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCardItem('**** **** **** 1921', '07/25', Colors.orange, 0),
          const SizedBox(width: 10),
          _buildCardItem('**** **** **** 1234', '12/24', Colors.purple, 1),
        ],
      ),
    );
  }

  // Card Item Builder
  Widget _buildCardItem(
      String cardNumber, String expiryDate, Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
      },
      child: Container(
        width: 200,
        height: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: selectedCardIndex == index
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('VISA',
                style: TextStyle(
                    color: Colors.white, fontSize: 18)), // Increased font size
            const SizedBox(height: 15),
            Text(cardNumber,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16)), // Increased font size
            const SizedBox(height: 15),
            Text(expiryDate,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16)), // Increased font size
          ],
        ),
      ),
    );
  }

  // Payment Method Options (Google Pay, Apple Pay, PayPal)
  Widget _buildPaymentMethodOptions() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.g_mobiledata, size: 50),
        Icon(Icons.apple, size: 50), // Increased icon size
        Icon(Icons.payment, size: 50), // Increased icon size
      ],
    );
  }
}
