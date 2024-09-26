import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatusbyDialog);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
        messageText: const Center(
          child: Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        isDismissible: false,
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(days: 1),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        margin: const EdgeInsets.symmetric(
            horizontal: 90, vertical: 80), // Shortens the width
        padding: const EdgeInsets.all(
            16), // Adds padding to make the content more compact
        snackStyle:
            SnackStyle.FLOATING, // Makes the snackbar float above the UI
        borderRadius: 10, // Add some styling to make it more visually distinct
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  void _updateConnectionStatusbyDialog(
      List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Check if the dialog is already open to prevent multiple dialogs
      if (Get.isDialogOpen != true) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.redAccent, // Custom background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded corners
            ),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Connection Error',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            content: const Text(
              'No Internet Connection. Please check your network settings.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  // Exit the app when "OK" is pressed
                  Get.back(); // Preferred method to exit the app
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16), // Text color inside button
                ),
              ),
            ],
          ),
          barrierDismissible: false, // Prevent dismissing by tapping outside
          useSafeArea: false, // Ensures the dialog shows even with navigation
        );
      }
    } else {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close the dialog if it's open when internet is restored
      }
    }
  }
}
