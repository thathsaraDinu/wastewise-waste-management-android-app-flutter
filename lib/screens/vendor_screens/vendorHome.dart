// ignore: file_names
import 'package:flutter/material.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart'; // Import for background image
import 'package:waste_wise/screens/vendor_screens/vendorHomePage.dart'; // Vendor Home Page
import 'package:waste_wise/screens/vendor_screens/vendor_history_page.dart'; // History page
import 'package:waste_wise/screens/vendor_screens/vendor_profile_page.dart'; // Profile page
import 'package:waste_wise/screens/vendor_screens/accepted_pickups.dart'; // Import the new Pickups page

class VendorHome extends StatefulWidget {
  final int selectedIndex;

  const VendorHome({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Set the initial selected index
  }

  // Define the pages to navigate to
  final List<Widget> _pages = <Widget>[
    const VendorHomePage(), // Vendor home page (dashboard)
    const AcceptedPickups(), // Pickups page
    const VendorHistoryPage(), // History page
    const VendorProfilePage(), // Profile page
  ];

  // Handle navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      // Use the Background Image Wrapper
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make the scaffold background transparent
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Current selected index
          onTap: _onItemTapped, // Handle taps
          backgroundColor: Colors.white, // Background color for the nav bar
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green[600], // Color for selected item
          unselectedItemColor: Colors.grey[500], // Color for unselected items
          showUnselectedLabels: false, // Hide unselected labels
          showSelectedLabels: true, // Show selected labels
          elevation: 15, // Adds shadow effect
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon:
                  Icon(Icons.home, size: 30), // Active icon with larger size
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined), // Pickups icon
              activeIcon: Icon(Icons.local_shipping,
                  size: 30), // Active icon with larger size
              label: 'Pickups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon:
                  Icon(Icons.history, size: 30), // Active icon with larger size
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon:
                  Icon(Icons.person, size: 30), // Active icon with larger size
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
