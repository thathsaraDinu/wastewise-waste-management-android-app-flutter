import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart'; // Import for FirebaseUserRepo
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
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

    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Vendor Profile'),
          backgroundColor: Colors.green[600],
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Add search functionality if needed
              },
            ),
          ],
        ), // Background color
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), // Padding for the page
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: [
                // Profile Icon with hardcoded name and email
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey, // Placeholder background
                  child: Icon(
                    Icons.person, // Profile icon
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16), // Space between avatar and text
                const Text(
                  'Eshan Nayanapriya', // Hardcoded Name
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8), // Space between name and email
                const Text(
                  'eshan@email.com', // Hardcoded Email
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // Spacing before account settings

                // User information card (Removed StreamBuilder as it's not needed)

                const SizedBox(height: 30), // Spacing before settings

                // Settings Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Settings option with icon
                      ListTile(
                        leading:
                            const Icon(Icons.settings, color: Colors.black),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Action for settings option
                        },
                      ),
                      const Divider(),

                      // Username option with icon
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.black),
                        title: const Text('Username'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Action for username option
                        },
                      ),
                      const Divider(),

                      // Password option with icon
                      ListTile(
                        leading: const Icon(Icons.lock, color: Colors.black),
                        title: const Text('Password'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Action for password option
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30), // Spacing before logout button

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutConfirmation(userRepo); // Show logout dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Logout button color
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutConfirmation(FirebaseUserRepo userRepo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut(userRepo); // Call sign out method
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Button color
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
