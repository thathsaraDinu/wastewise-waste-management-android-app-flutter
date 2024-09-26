import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FirestoreProvider with ChangeNotifier {
  Future<void> performFirestoreOperation(
      Function firestoreOperation, BuildContext context) async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none) ) {
      // No internet connection, show a message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No internet connection! Please try again later.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Proceed with the Firestore operation
    await firestoreOperation();
  }
}
