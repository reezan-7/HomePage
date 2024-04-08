import 'package:flutter/material.dart';
import 'package:home_page/FormsDirectory/api_services.dart';

import 'FormsDirectory/location_model.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {

  List<States> stateList=[];
  List<Province> provinceList=[];

  //temp list
  List<Province> tempList=[];

  String? states;
  String? province;

  var isLoading=true;

  populateDropdowns()async{
    LocationModel data=await getData();
    setState(() {
      stateList=data.states;
      provinceList=data.provinces;
      isLoading = false;
    });
  }

  @override
  void initState() {
    populateDropdowns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dependent Dropdown'),
      ),
      body: Center(
        child:
        isLoading? CircularProgressIndicator():
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //states dropdown
            DropdownButton(
              hint: const Text('Please select a state'),
              value: states,
                items: stateList.map((e){
                  return DropdownMenuItem(
                    value: e.id.toString(),
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (newValue){
                  setState((){
                    province=null;
                    states=newValue.toString();
                    //filtering acc to states
                    tempList = provinceList.where((element) =>element.stateId.toString()==states.toString(),
                    ).toList();
                  });
                },
            ),

             //province dropdown
            DropdownButton(
              hint: const Text('Please select a province'),
              value: province,
              items: tempList.map((e){
                return DropdownMenuItem(
                  value: e.id.toString(),
                  child: Text(e.name),
                );
              }).toList(),
              onChanged: (newValue){
                setState((){
                  province=newValue.toString();
                });
              },
            )

          ],
        ),
      ),
    );
  }
}
