import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/screens/vendor_screens/vendorHome.dart';

class VendorLoginPage extends StatefulWidget {
  const VendorLoginPage({super.key});

  @override
  State<VendorLoginPage> createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      // Simulate the login process
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });
      // Navigate to vendor home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>const VendorHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.black), // Back button set to black
            onPressed: () {
              Navigator.pop(
                  context); // Pops the current screen and returns to the previous screen
            },
          ),
          iconTheme: const IconThemeData(
              color: Colors.black), // Ensures the back button is always black
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/waste-wise-high-resolution-logo-transparent.png',
                  height: 100,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Vendor Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 16),
                    ),
                  )
                else
                  const SizedBox(height: 10),
                Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(top: 15.0),
                    color: const Color.fromARGB(255, 213, 217, 213)
                        .withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 80.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 5,
                                ),
                                child: _isLoading != true
                                    ? const Text(
                                        'Login as Vendor',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      )
                                    : const SizedBox(
                                        width: 25.0,
                                        height: 25.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          color: Colors.white,
                                        ),
                                      )),
                          ],
                        ),
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
}
