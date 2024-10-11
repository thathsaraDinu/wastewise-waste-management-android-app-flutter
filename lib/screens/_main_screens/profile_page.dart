import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut(userRepo) async {
    try {
      await userRepo.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/signupandlogin', (routes) => false);
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
      
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center column vertically
          children: [
            Text('Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    color: Colors.green[900])),
            const SizedBox(height: 50),
            StreamBuilder<MyUser>(
              stream: userRepo.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show error if there is one
                } else if (!snapshot.hasData) {
                  return const Text(
                      'No user data available'); // Handle case where there's no data
                } else {
                  MyUser user = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center everything vertically
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Align items to the center horizontally
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            Colors.green, // Green accent for avatar
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Space between avatar and name
                      Text(
                        'Name: ${user.name}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800], // Darker shade for name
                        ),
                      ),
                      const SizedBox(
                          height:
                              8), // Slightly larger space between name and email
                      Text(
                        'Email: ${user.email}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600], // Lighter shade for email
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20), // Spacing between text and button
            ElevatedButton(
              onPressed: () {
                _signOut(userRepo);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30), // Space below logout button
            const Divider(), // Divider for visual separation
            const SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Change Password screen
                Navigator.pushNamed(context, '/changePassword');
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Privacy Policy screen
                Navigator.pushNamed(context, '/privacyPolicy');
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Terms of Service screen
                Navigator.pushNamed(context, '/termsOfService');
              },
            ),
          ],
        ),
      ),
    );
  }
}
