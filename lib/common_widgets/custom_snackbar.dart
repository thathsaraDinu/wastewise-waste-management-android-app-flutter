import 'package:flutter/material.dart';

class CustomSnackbar {
  static final CustomSnackbar _instance = CustomSnackbar._internal();
  OverlayEntry? _activeOverlay; // To store the active OverlayEntry
  bool _isSnackbarActive = false; // Flag to check if a Snackbar is active

  // Private constructor for Singleton
  CustomSnackbar._internal();

  // Factory method to return the same instance
  factory CustomSnackbar() {
    return _instance;
  }

  // Static method to display Snackbar from the top using OverlayEntry
  void show({
    required BuildContext context,
    required String message,
    // Default color if none provided
    Duration duration = const Duration(seconds: 3),
    required String
        type, // Message type: 'e', 'w', 's' for error, warning, success
  }) {
    // If a Snackbar is already showing, ignore new calls
    if (_isSnackbarActive) {
      return;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double topPosition = screenHeight / 2;

    _isSnackbarActive = true; // Set the flag to true when a Snackbar is shown

    // Create an OverlayEntry for the Snackbar
    _activeOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: 80,
        right: 80,
        top:
            topPosition - 80, // Set this value to adjust how far from the top you want the Snackbar

        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: type == 'e'
                  ? Colors.red[800]!.withOpacity(0.9)
                  : type == 'w'
                      ? Colors.orange[800]!.withOpacity(0.9)
                      : Colors.green[800]!.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Text(
                  type == 'e'
                      ? 'Error'
                      : type == 'w'
                          ? 'Warning'
                          : 'Success',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the OverlayEntry into the Overlay
    Overlay.of(context).insert(_activeOverlay!);

    // Dismiss the Snackbar after the given duration
    Future.delayed(duration, () {
      _removeOverlay();
    });
  }

  // Remove the active Overlay and reset the flag
  void _removeOverlay() {
    if (_activeOverlay != null) {
      _activeOverlay?.remove(); // Remove the overlay from the screen
      _activeOverlay = null; // Set the active overlay to null
      _isSnackbarActive =
          false; // Reset the flag so a new Snackbar can be shown
    }
  }
}
