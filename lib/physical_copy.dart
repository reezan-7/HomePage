import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhysicalCopyPage extends StatefulWidget {
  final Map<String, String> formData;
  const PhysicalCopyPage({super.key, required this.formData});

  @override
  State<PhysicalCopyPage> createState() => _PhysicalCopyPageState();
}

class _PhysicalCopyPageState extends State<PhysicalCopyPage> {

  TextEditingController imageController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      // Set image path to the image controller
      setState(() {
        imageController.text = pickedImage.path;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      // Check if location permission is granted
      if (!(await Permission.location.isGranted)) {
        // Request permission if not granted
        PermissionStatus permissionStatus = await Permission.location.request();

        // Handle different permission statuses
        if (permissionStatus != PermissionStatus.granted) {
          // Permission not granted, handle accordingly
          return null;
        }
      }

      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting location: $e');
      // Handle error getting location
      return null;
    }
  }

  Future<void> _uploadFormDataAndImage() async {
    Position? position = await _getCurrentLocation();
    if (position == null) {
      // Handle situation where location services are not available or permission is denied
      return;
    }

    // Combine form data and image path
    Map<String, String> combinedData = {
      ...widget.formData,
      'imagePath': imageController.text,
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    };

    // Convert combined data to JSON
    String jsonData = jsonEncode(combinedData);
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.235.0.221:8000/farmerregister/farmer_consent_form/'),
      );

      // Attach form data fields
      request.fields.addAll(combinedData);

      // Attach image file
      final pickedImage = File(imageController.text);
      request.files.add(http.MultipartFile(
        'image',
        pickedImage.readAsBytes().asStream(),
        pickedImage.lengthSync(),
        filename: 'consent_image.jpg',
      ));

      // Send request
      var streamedResponse = await request.send();

      // Handle response
      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        // Show success message using Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Form submitted successfully'),
            backgroundColor: Colors.green, // Change color to green for success
          ),
        );
      } else {
        // Show error message using Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form: ${streamedResponse.statusCode}'),
            backgroundColor: Colors.red, // Change color to red for error
          ),
        );
      }
    } on SocketException {
      // No internet connection
      print('No Internet');
      // Optionally, you can show a message to the user here
    } catch (e) {
      // Other errors
      print('Error: $e');
      // Optionally, you can show an error message here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Physical Copy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: imageController, // Controller for image path
              decoration: const InputDecoration(
                hintText: 'Image Path',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showImagePickerBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.amber, // Change button color to yellow
              ),
              child: const Text('Capture Image'),
            ),
            ElevatedButton(
              onPressed: _uploadFormDataAndImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple, // Change button color to yellow
              ),
              child: Text('Upload Form Data and Image'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Picture'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


