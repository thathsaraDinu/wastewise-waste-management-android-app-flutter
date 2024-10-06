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
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/waste-wise-high-resolution-logo-transparent.png',
                    height: 150,
                  ),
                  const SizedBox(height: 40,),
                  const SizedBox(
                    width: 30.0, // Set width
                    height: 30.0, // Set height
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 44, 113, 47)), // Color of the indicator
                      strokeWidth: 4.0, // Width of the indicator stroke
                      backgroundColor:
                          Colors.transparent, // Background color behind the indicator
                    ),
                  ),
                ],
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
