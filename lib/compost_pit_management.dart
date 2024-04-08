import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'FormsDirectory/village_list.dart';

class CPMPage extends StatefulWidget {
  const CPMPage({super.key});

  @override
  State<CPMPage> createState() => _CPMPageState();
}

class _CPMPageState extends State<CPMPage> {
  String? selectedValue;
  TextEditingController imageController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  //image capturing
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      // Set image path to the image controller
      setState(() {
        imageController.text = pickedImage.path;
      });
    }
  }

  Future<List<VillageList>> getPost() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.235.0.221:8000/farmerregister/village_list/'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) {
          final map = e as Map<String, dynamic>;
          return VillageList(
            villageId: map['village_id'],
            villageName: map['village_name'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet');
    } catch (e) {
      throw Exception('Error Fetching Data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COMPOST-PIT-MANAGEMENT',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.amber[700],
        centerTitle: true,
        leading: Icon(
          Icons.agriculture, // Choose appropriate icon for consent form
          color: Colors.white, // Set color of the icon
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                color: Colors.amber[100], // Highlighted area color
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      child: FutureBuilder<List<VillageList>>(
                        future: getPost(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show a loading indicator while waiting for the future to complete
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Show the error message if an error occurs
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            );
                          } else if (snapshot.hasData) {
                            // Render the dropdown button if data is available
                            return DropdownButtonFormField(
                              isExpanded: true,
                              hint: Text(
                                  '   Select a Village',
                                style: TextStyle(color: Colors.black),
                              ),
                              value: selectedValue,
                              icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                              iconSize: 24, // Set icon size
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              items: snapshot.data!.map((e) {
                                return DropdownMenuItem(
                                  value: e.villageId.toString(),
                                  child: Text(
                                    e.villageName.toString(),
                                    style: TextStyle(
                                    color: Colors.black, // Set dropdown item text color
                                  ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedValue = value;
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a village';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[350], // Set dropdown background color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none, // Hide dropdown border
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                              ),
                            );
                          } else {
                            // If none of the above conditions are met, return an empty container
                            // This case shouldn't typically happen, but it's good to handle it
                            return Container();
                          }
                        },
                      ),
                    ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 45),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: null, // Set initial value to null
                  hint: Text(
                    '   Please select a farmer',
                    style: TextStyle(
                      color: Colors.black, // Change hint text color
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down), // Add dropdown icon
                  iconSize: 24, // Set icon size
                  elevation: 16,
                  style: TextStyle(color: Colors.black), // Set text color
                  onChanged: (value) {
                    // Handle onChanged event if needed
                  },
                  items: [], // Empty items list
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[350], // Set dropdown background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // Hide dropdown border
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                ),
              ),
                  ],
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.blueAccent,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () => _showNameInputDialog(context),
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Center(
                          child: Text(
                            'Pit-Identification',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Card(
                    color: Colors.orange,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Center(
                        child: Text('Waste-feed',style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.green,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Center(
                        child: Text('Turning',style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Card(
                    color: Colors.purple,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Center(
                        child: Text('Soil-report',style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showNameInputDialog(BuildContext context) {
    TextEditingController dateController = TextEditingController(); // Controller for the date input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field for image path
              TextField(
                controller: imageController,
                decoration: InputDecoration(
                  hintText: 'Image Path',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      _showImagePickerBottomSheet(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10), // Spacer
              // Text field for date
              TextFormField(
                readOnly: true, // Make the text field read-only
                controller: dateController,
                decoration: InputDecoration(
                  hintText: 'Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      // Show date picker dialog
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), // Set initial date to current date
                        firstDate: DateTime(2000), // Set range for selecting dates
                        lastDate: DateTime(2100),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light(), // Use light theme for date picker
                            child: child!,
                          );
                        },
                      );
                      // Update the text field with the selected date
                      if (selectedDate != null) {
                        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                        dateController.text = formattedDate; // Update text field with selected date
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add form submission logic here
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
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



