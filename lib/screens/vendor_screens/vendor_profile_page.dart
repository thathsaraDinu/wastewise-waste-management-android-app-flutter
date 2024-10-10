import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart'; // Import for FirebaseUserRepo
import 'package:provider/provider.dart'; // Import for dependency injection

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({Key? key}) : super(key: key);

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  Future<void> _signOut(userRepo) async {
    try {
      await userRepo.signOut(); // Sign out the vendor
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/signupandlogin',
            (routes) => false); // Redirect after logout
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-out failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Padding for the page
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              // User information card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: StreamBuilder<MyUser>(
                    stream: userRepo.user, // Listening for vendor user data
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error if any
                      } else if (!snapshot.hasData) {
                        return const Text(
                            'No user data available'); // Handle no data case
                      }

                      MyUser user = snapshot.data!; // Vendor data

                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: Eshan Nayanapriya', // Display vendor name
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10), // Spacing
                          Text(
                            'Email: eshan@gmail.com', // Display vendor email
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30), // Spacing
              ElevatedButton(
                onPressed: () {
                  _signOut(userRepo); // Call sign out when button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600], // Button color
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
