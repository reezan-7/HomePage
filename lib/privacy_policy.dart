import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FormsDirectory/village_list.dart';
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _DropdownApiState();
}

class _DropdownApiState extends State<PrivacyPolicyPage> {
  Future<List<VillageList>> getPost ()async{
    try{
      final response = await http.get(Uri.parse('http://172.235.0.221:8000/farmerregister/village_list/'));
      final body = json.decode(response.body) as List;

      if(response.statusCode ==200){
        return body.map((e){
          final map =e as Map<String,dynamic>;
          return VillageList(
            villageId:map['id'],
            villageName:map['title'],
          );
        }).toList();
      }
    } on SocketException{
      throw Exception('No Internet');
    }
    throw Exception('Error Fetching Data');
  }

  var selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown API'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<VillageList>>(
              future: getPost(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return DropdownButton(
                    hint: Text('Select a field'),
                      isExpanded: true,
                      value: selectedValue,
                      items:snapshot.data!.map((e){
                        return DropdownMenuItem(
                          value: e.villageId.toString(),
                            child: Text(e.villageId.toString()));
                      }).toList() ,
                      onChanged: (value){
                      selectedValue=value;
                      setState(() {

                      });
                  }
                  );
                }else{
                  return CircularProgressIndicator();
                }
              }
            )
          ],
        ),
      ),
    );
  }
}

