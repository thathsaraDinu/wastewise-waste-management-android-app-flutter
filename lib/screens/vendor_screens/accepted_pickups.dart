import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';

class AcceptedPickups extends StatelessWidget {
  const AcceptedPickups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Accepted Pickups'),
          backgroundColor: Colors.green[600],
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'No Accepted Pickups Yet!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'All your accepted pickups will show up here.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
