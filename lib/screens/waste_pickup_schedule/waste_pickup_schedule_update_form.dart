import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:waste_wise/screens/_main_screens/waste_pickup_schedule_main.dart';

const List<String> list = <String>[
  'E-Waste',
  'Paper Waste',
  'Metal Waste',
  'Plastic Waste'
];

class WastePickupScheduleUpdateForm extends StatefulWidget {
  final Map<String, dynamic> pickup;
  final String documentId;

  const WastePickupScheduleUpdateForm({
    super.key,
    required this.pickup,
    required this.documentId,
  });

  @override
  State<WastePickupScheduleUpdateForm> createState() =>
      _WastePickupScheduleUpdateFormState();
}

class _WastePickupScheduleUpdateFormState
    extends State<WastePickupScheduleUpdateForm> {
  String dropdownValue = list.first;
  final TextEditingController _dateController =
      TextEditingController(text: "Choose date");
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late String latitude = '';
  late String longitude = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.pickup['wasteType'] ?? list.first;
    _dateController.text = widget.pickup['scheduledDate'] ?? "Choose date";
    addressController.text = widget.pickup['address'] ?? '';
    phoneController.text = widget.pickup['phone'] ?? '';
    descriptionController.text = widget.pickup['description'] ?? '';
    _getCurrentLocation().then((value) {
      latitude = '${value.latitude}';
      longitude = '${value.longitude}';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  Future<void> schedulePickup() async {
    String wasteType = dropdownValue;
    String scheduledDate = _dateController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String description = descriptionController.text;
    // Validate fields
    if (scheduledDate == "Choose date" ||
        address.isEmpty ||
        phone.isEmpty ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      String? imageUrl;
      if (_imageFile != null) {
        // Upload the image to Firebase Storage
        try {
          final ref = FirebaseStorage.instance
              .ref()
              .child('waste_pickups/${DateTime.now().toIso8601String()}');
          await ref.putFile(_imageFile!);
          imageUrl = await ref.getDownloadURL(); // Get the download URL
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: $e'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      try {
        await FirebaseFirestore.instance
            .collection('waste_pickups')
            .doc(widget.documentId)
            .update({
          'wasteType': wasteType,
          'scheduledDate': scheduledDate,
          'address': address,
          'phone': phone,
          'imageUrl': imageUrl,
          'latitude': latitude,
          'longitude': longitude,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WastePickupScheduleMain()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waste pickup updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule waste pickup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Update your schedule',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select waste type:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              DropdownMenu<String>(
                inputDecorationTheme: const InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green[50])),
                width: MediaQuery.of(context).size.width - 32,
                initialSelection: dropdownValue,
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(height: 15),
              const Text("Select a date:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 15),
              const Text("Address:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                cursorColor: Colors.black,
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  hintText: 'Enter address',
                ),
              ),
              const SizedBox(height: 15),
              const Text("Phone number:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                cursorColor: Colors.black,
                controller: phoneController,
                keyboardType: TextInputType.phone, // Show phone keyboard
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly, // Allow only numeric input
                  LengthLimitingTextInputFormatter(
                      15), // Limit input to 15 characters
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  hintText: 'Enter phone number',
                ),
              ),
              const SizedBox(height: 15),
              const Text("Snapshot:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ImageDisplay(imageUrl: widget.pickup['imageUrl']),
              const SizedBox(height: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Colors.green.shade600, width: 1),
                        ),
                      ),
                      child: Text('Capture a Snapshot',
                          style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text("Description (optional):",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                cursorColor: Colors.black,
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  hintText: 'Enter description',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: schedulePickup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Update Schedule',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  final String? imageUrl;

  const ImageDisplay({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: double.infinity, // Set width as needed
                height: 280, // Set height as needed
                fit: BoxFit.fill, // Adjusts how the image fits
              )
            : const Text("No image available", style: TextStyle(fontSize: 16)));
  }
}
