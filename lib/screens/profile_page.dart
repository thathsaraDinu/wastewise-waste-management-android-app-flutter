import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';

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
      Navigator.pushNamedAndRemoveUntil(context, '/signupandlogin', (routes) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-out failed: ${e.toString()}')),
      );
      print('Sign-out failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center column vertically
        children: [
          StreamBuilder<MyUser>(
            stream: userRepo.user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while waiting
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show error if there is one
              } else if (!snapshot.hasData) {
                return Text(
                    'No user data available'); // Handle case where there's no data
              }

              MyUser user = snapshot.data!;

              // Display the user information (for example, name and email)
              return Column(
                children: [
                  Text('Name: ${user.name}'),
                  Text('Email: ${user.email}'),
                ],
              );
            },
          ),
          const SizedBox(
              height: 20), // Add spacing between the text and the button
          ElevatedButton(
            onPressed: () {
              _signOut(userRepo);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
