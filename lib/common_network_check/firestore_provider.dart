import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:waste_wise/common_widgets/custom_snackbar.dart';

class FirestoreProvider with ChangeNotifier {
  // Function to check internet access with a timeout

  Future<void> performFirestoreOperation(
      Function firestoreOperation, BuildContext context) async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());

    // If no connectivity, show a message
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        CustomSnackbar().show(
            context: context, message: 'No Internet Connection!', type: 'e');
      }
      return;
    }
    // Check if there's actual internet access

    try {
      final response =
          await http.get(Uri.parse('https://www.google.com')).timeout(
        const Duration(seconds: 5), // Timeout duration for HTTP request
        onTimeout: () {
          throw const SocketException('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        // Internet is available, proceed with Firestore operation
        await firestoreOperation();
      } else {
        // Handle unexpected HTTP response
        throw const SocketException('No Internet Access');
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        CustomSnackbar().show(
          context: context,
          message: 'Connection Timeout! Please Check your Internet',
          type: 'e',
        );
      }
      rethrow;
    }

    // Proceed with the Firestore operation
  }
}
