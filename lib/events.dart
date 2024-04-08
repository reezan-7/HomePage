import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FormsDirectory/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<Contact> contacts = List.empty(growable: true);
  TextEditingController nameController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  TextEditingController imageController = TextEditingController();

  int selectedIndex=-1;

  late SharedPreferences sp;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getSharedPreferences()async{
    sp=await SharedPreferences.getInstance();
    readFromSp();
  }

  saveIntosp(){
    List<String> contactListString=contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    sp.setStringList('myData', contactListString);
  }
  readFromSp(){
    List<String>? contactListString = sp.getStringList('myData');
    if(contactListString!=null){
      contacts= contactListString.map((contact) => Contact.fromJson(json.decode(contact))).toList();
    }
    setState(() {

    });
  }
  void uploadContactsToFirebase(BuildContext context) async{
    try {
      List<String> imageUrls = await _uploadImages();
      await Future.wait(contacts.asMap().entries.map((entry) {
      return _firestore.collection('contacts').add({
        'name': entry.value.name,
        'contact': entry.value.contact,
        'image': imageUrls[entry.key],
      });
    }));
    _showSnackbar(context,'Upload to Firebase Successful');
    } catch (e) {
      _showSnackbar(context,'Upload to Firebase Failed');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      // Set image path to the image controller
      setState(() {
        imageController.text = pickedImage.path;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageController.text = pickedImage.path;
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    try {
      await Future.wait(contacts.map((contact) async {
        if (contact.image.isNotEmpty) {
          File imageFile = File(contact.image);
          String imageName = DateTime.now().millisecondsSinceEpoch.toString();
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('images')
              .child('$imageName.jpg');
          await ref.putFile(imageFile);
          String imageUrl = await ref.getDownloadURL();
          imageUrls.add(imageUrl);
        } else {
          imageUrls.add('');
        }
      }));
    } catch (e) {
      print('Error uploading images: $e');
    }
    return imageUrls;
  }
  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shared Preferences')
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:[
            const SizedBox(height: 10,),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Contact Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0),
                  )
                )
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                  hintText: 'Contact Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),
                      )
                  )
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  String name = nameController.text.trim();
                  String contact = contactController.text.trim();
                  String imagePath = imageController.text.trim();
                  if(name.isNotEmpty && contact.isNotEmpty){
                    setState(() {
                      nameController.text='';
                      contactController.text='';
                      imageController.text = '';
                      contacts.add(Contact(name: name, contact: contact,image: imagePath));
                    });
                    saveIntosp();
                  }
                },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple, // Text color
                    ),
                    child: const Text('Save')),
                ElevatedButton(onPressed: (){
                  String name = nameController.text.trim();
                  String contact = contactController.text.trim();
                  String imagePath = imageController.text.trim();
                  if(name.isNotEmpty && contact.isNotEmpty) {
                    setState(() {
                      nameController.text = '';
                      contactController.text = '';
                      imageController.text = '';
                      contacts[selectedIndex].name=name;
                      contacts[selectedIndex].contact=contact;
                      contacts[selectedIndex].image = imagePath;
                      selectedIndex=-1;
                     });
                    saveIntosp();
                    }
                },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple, // Text color
                    ),
                    child: const Text('Update')),
              ],
            ),
            const SizedBox(height: 10,),
            contacts.isEmpty? const Text('No Contacts yet...',style: TextStyle(fontSize: 22),):
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                  itemBuilder: (context,index)=>getRow(index),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                uploadContactsToFirebase(context); // Call the function to upload contacts
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Change button color if needed
              ),
              child: const Text('Upload to Firebase'), // Change button text if needed
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
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: index%2==0? Colors.deepPurpleAccent:Colors.purple,
          foregroundColor: Colors.white,
          child: Text(contacts[index].name[0],style: const TextStyle(fontWeight: FontWeight.bold),),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contacts[index].name,style: const TextStyle(fontWeight: FontWeight.bold),),
            Text(contacts[index].contact),
            Text(contacts[index].image),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children:[
              InkWell(
                  onTap: ((){
                    nameController.text=contacts[index].name;
                    contactController.text=contacts[index].contact;
                    imageController.text = contacts[index].image;
                    setState(() {
                      selectedIndex=index;
                    });
                  }),
                  child: const Icon(Icons.edit)),
              const SizedBox(width: 10,),
              InkWell(
                  onTap: ((){
                    setState(() {
                      contacts.removeAt(index);
                    });
                    saveIntosp();
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
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

