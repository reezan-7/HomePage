import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_page/physical_copy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'FormsDirectory/form_submit.dart';
import 'FormsDirectory/village_list.dart';

class ConsentFormPage extends StatefulWidget {
  const ConsentFormPage({super.key});

  @override
  State<ConsentFormPage> createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {

  //temp print

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController landDetailsController = TextEditingController();
  TextEditingController totalAreaController = TextEditingController();
  TextEditingController majorCropsController = TextEditingController();
  TextEditingController fertilizerTypeController = TextEditingController();
  TextEditingController fertilizerQuantityController = TextEditingController();
  TextEditingController yearsController = TextEditingController();
  TextEditingController signatureController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedIDProof;
  int? selectedNumber;
  String? selectedValue;

  List<IDProofOption> idProofOptions = [
    IDProofOption(id: 'aadhar', name: 'Aadhar'),
    IDProofOption(id: 'voter', name: 'Voter ID'),
    IDProofOption(id: 'pan', name: 'PAN Card'),
    IDProofOption(id: 'dl', name: 'Driving License'),
  ];

  //crops cycle
  List<CropsCycleNumber> cropsCycleNumber = [
    CropsCycleNumber(id: '1', number: '1'),
    CropsCycleNumber(id: '2', number: '2'),
    CropsCycleNumber(id: '3', number: '3'),
  ];

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^(\+91)?\d{10}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
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
            'CONSENT-FORM',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.amber[700],
        centerTitle: true,
        leading: Icon(
          Icons.description, // Choose appropriate icon for consent form
          color: Colors.white, // Set color of the icon
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[100], // Amber color for the container
                    borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 35), // Add padding inside the container
                  child: Column(
                    children: [
                      Text(
                        "ನಗರ ಸಭೆ ಮತ್ತು ರೆೈತ್ರ ಸಹಭಾಗಿತ್ವದಲ್ಲಿಘನ ತ್ಾಾಜ್ಾ ನಿರ್ವಹಣ",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 10, decoration: TextDecoration.underline,),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "City-Farmer Partnership for SWM in Chikkaballapura",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ರೆೈತ್ರ ಒಪ್ಪಿಗೆ ಪತ್ರ / Farmers consent form",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35), // Add padding inside the container
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'ರ ೈತರ ಪೂರ್ಣ ಹ ಸರು/Farmer Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35), // Add padding inside the container
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly // Allow only digits
                    ],
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      labelText: 'ಸಂಪರ್ಣ ಸಂಖ್ ೆ/Contact Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: validatePhoneNumber,
                    onSaved: (value) {
                      int? contactNumber = int.tryParse(value!); // Convert string to integer
                      // Do something with the integer value, for example, save it
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 35),
                  child: DropdownButtonFormField<String>(
                    value: selectedIDProof,
                    hint: Text('Select ID Proof'),
                    onChanged: (newValue){
                      setState(() {
                        selectedIDProof=newValue;
                      });
                    },
                    items: idProofOptions.map((IDProofOption option){
                      return DropdownMenuItem<String>(
                        value: option.id,
                          child: Text(option.name),
                      );
                    }).toList(),
                    validator: (value){
                      if(value==null){
                        return 'Please select an ID proof';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: idNumberController,
                    decoration: InputDecoration(
                      labelText: 'ID Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter ID number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
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
                          hint: Text('Select a Village'),
                          value: selectedValue,
                          items: snapshot.data!.map((e) {
                            return DropdownMenuItem(
                              value: e.villageId.toString(),
                              child: Text(e.villageName.toString()),
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: landDetailsController,
                    decoration: InputDecoration(
                      labelText: 'ಜಮೀನಿನ ವಿವರ/Land details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter land details';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: totalAreaController,
                    keyboardType: TextInputType.number, // Set keyboard type to number
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly // Allow only digits
                    ],
                    decoration: InputDecoration(
                      labelText: 'ಒಟ್ಟು ರ್ಷಿಭೂಮಿಯ ವಿಸ್ತೀರ್ಣ/Total Area of Farmland',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the Total Area';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      int? totalArea = int.tryParse(value!); // Convert string to integer
                      // Do something with the integer value, for example, save it
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: majorCropsController,
                    decoration: InputDecoration(
                      labelText: 'ಮುಖ್ೆ ಬ ಳ ಗಳು/Major Crops Grown',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the crops grown';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 35),
                  child: DropdownButtonFormField<int>(
                    value: selectedNumber,
                    hint: Text('No.of Crop Cycle Per Year'),
                    onChanged: (int? value){
                      setState(() {
                        selectedNumber=value;
                      });
                    },
                    items: cropsCycleNumber.map((CropsCycleNumber option){
                      return DropdownMenuItem<int>(
                        value: int.parse(option.id),
                        child: Text(option.number),
                      );
                    }).toList(),
                    validator: (int? value){
                      if(value==null){
                        return 'Please select a number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: fertilizerTypeController,
                    decoration: InputDecoration(
                      labelText: 'Types of Fertilizer Used',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter type';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: fertilizerQuantityController,
                    keyboardType: TextInputType.number, // Set keyboard type to number
                    decoration: InputDecoration(
                      labelText: 'Quantity of Fertilizer Used',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter quantity';
                      }
                      // You may add additional validation for numeric input if needed
                      return null;
                    },
                    onSaved: (value) {
                      // If you want to convert the entered value to an integer
                      int? quantity = int.tryParse(value!);
                      // Handle the integer value as needed
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: TextFormField(
                    controller: yearsController,
                    keyboardType: TextInputType.number, // Set keyboard type to number
                    decoration: InputDecoration(
                        labelText: 'Number of Years of Farming on this Land',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        )
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the number of years';
                      }
                      // You may add additional validation for numeric input if needed
                      return null;
                    },
                    onSaved: (value) {
                      // If you want to convert the entered value to an integer
                      int? yearsOfFarming = int.tryParse(value!);
                      // Handle the integer value as needed
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 35),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // Outline border
                      borderRadius: BorderRadius.circular(10), // Optional: border radius
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'ನರನು ಚರ್ೆಬಳರಾಪುರ ನಗರಸಭ ಯಂದ ನಿೀಡಲರಗುವ ಬ ೀಪಣಡಿಸ್ದ ಹಸ್ ತ್ರೆಜೆವನುು ಸರವಯವ ಗ್\n ೂಬಬರವರಗಿ'
                                'ಪರಿವತಿಣಸ್ ನನು ಜಮೀನಿನಲ್ಲಿಬಳಸಲುಒಪ್ಪಿದ ದೀನ . ಈ ಯೀಜನ ಯಲ್ಲಿಭರಗವಹಿಸಲು ನರನು ಸವಯಂಪ ಾೀರಣ ಯಂದ\n ಒಪುಿತ್ ತೀನ.\n\n\n'
                    'I am willing to accept of my own free will and consent the segregated wet waste supplied by\n'
                        'Chikkaballapura City Municipal Council (CCMC) at my farm to make organic compost for own\n'
                        'consumption. I voluntarily agree to participate in this project.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: dateController,// Make the text field read-only
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
                                        setState(() {
                                          dateController.text = formattedDate; // Update text field with selected date
                                        });
                                      }
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 77),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Signature',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter signature';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showUploadDialog(context);
                    } else {
                      // Form validation failed, display error messages
                      // You can optionally display error messages here
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple, // Change button color to yellow
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Initiate Image Upload'),
          content: Text('Would you like to upload the physical copy of the consent form?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to image upload screen or initiate image upload process
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhysicalCopyPage(
                    formData: {
                      "full_name": nameController.text,
                      "contact_number": numberController.text,
                      "identity_proof": selectedIDProof!,
                      "identity_proof_number": idNumberController.text,
                      "land_details": landDetailsController.text,
                      "total_area_of_farmland": totalAreaController.text,
                      "major_crops_grown": majorCropsController.text,
                      "no_of_crop_cycle_per_year": selectedNumber.toString(),
                      "type_of_fertilizers_used": fertilizerTypeController.text,
                      "quantity_of_fertilizers_used": fertilizerQuantityController.text,
                      "no_of_years_on_farming": yearsController.text,
                      "date": DateFormat('yyyy-MM-dd').format(DateTime.parse(dateController.text)),
                      "village_name": selectedValue!,
                    },
                  )),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class IDProofOption {
  final String id;
  final String name;

  IDProofOption({required this.id, required this.name});
}

//crops per cycle
class CropsCycleNumber {
  final String id;
  final String number;

  CropsCycleNumber({required this.id, required this.number});
}