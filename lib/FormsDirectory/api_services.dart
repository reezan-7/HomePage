import 'package:home_page/FormsDirectory/location_model.dart';
import 'package:http/http.dart' as http;

var link = "https://raw.githubusercontent.com/rjcalifornia/drop_example/master/json/states.json";

getData() async{
  var res = await http.get(Uri.parse(link));

  if(res.statusCode==200){
    LocationModel data = locationModelFromJson(res.body);
    return data;
  }
}