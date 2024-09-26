import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key, required this.routeName});
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<FirebaseUserRepo>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<MyUser>(
        stream: userRepo.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50.0, // Set width
                height: 50.0, // Set height
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green), // Color of the indicator
                  strokeWidth: 4.0, // Width of the indicator stroke
                  backgroundColor:
                      Colors.grey, // Background color behind the indicator
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == MyUser.empty) {
            if (kDebugMode) {
              print('no one is logged in');
            }
            // Navigate to login page if not authenticated
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signupandlogin',
                (routes) => false,
              );
            });
            // Placeholder while navigating
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SnackBar(content: Text('Welcome back, ${snapshot.data}'));
              Navigator.pushReplacementNamed(
                context,
                routeName,
              );
            });
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
