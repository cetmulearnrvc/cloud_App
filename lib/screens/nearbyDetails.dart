import 'package:flutter/material.dart';

class DataModel{
  String? landValue;
  String? lat;
  String? long;

  DataModel({this.landValue, this.lat, this.long});
}



class Nearbydetails extends StatefulWidget {
  late final String latitude;
late final String longitude;

   Nearbydetails({super.key,required this.latitude,required this.longitude});

  @override
  State<Nearbydetails> createState() => _NearbydetailsState();
}

class _NearbydetailsState extends State<Nearbydetails> {

  List<DataModel> data=[];
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Land Value of Nearby Locations'),backgroundColor: Colors.blue,),
      floatingActionButton: FloatingActionButton.extended(label: Text('Click me to add'),onPressed: (){
        setState(() {
          data.add(DataModel(
          landValue: "250,000 / cent",
          lat: "8.5280",
          long: "76.9410",
        ),
      );
        });
      }),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: data.isNotEmpty?ListView.separated(itemBuilder: (ctx,index){
          
          return ListTile(
            title: Text(data[index].landValue!),
            subtitle: Row(children: [
              Text('Latitude : ${data[index].lat}'),
              SizedBox(width: 30,),
              Text('Longitude : ${data[index].long}')
            ],),
          );
        }, separatorBuilder: (ctx,index){
          return Divider();
        }, itemCount: data.length) : Center(child: Text('Not Found'))
      )
    );
  }
}