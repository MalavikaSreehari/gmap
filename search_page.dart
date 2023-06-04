import 'package:farespy/Assistants/req_asst.dart';
import 'package:farespy/DataHandler/app_data.dart';
import 'package:farespy/Models/address.dart';
import 'package:farespy/Models/place_predictions.dart';
import 'package:farespy/divider_widget.dart';
import 'package:farespy/global/config_maps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionsList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(height: 215.0,
            decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 16.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7)),
                                  ]),
                                  child: Padding(padding: EdgeInsets.only(left: 25.0,top: 25.0, right: 25.0, bottom: 20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5.0,),
                                      Stack(
                                        children: [
                                          GestureDetector(onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back)),
                                          Center(
                                            child: Text("Set Dropoff"),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.0,),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/location.png",height: 16.0,width: 16.0),
                                          SizedBox(height: 18.0,),
                                          Expanded(child: Container(decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(5.0),
    
                                          ),
                                          child: Padding(padding: EdgeInsets.all(3.0),
                                          child: TextField(
                                            controller: pickUpTextEditingController,
                                            decoration: InputDecoration(hintText: "Pickup Location",
                                            fillColor: Colors.grey,
                                            filled: true,
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0)),
                                          ),),))
                                        ],
                                      ),
                                      SizedBox(height: 10.0,),
                                      Row(
                                        children: [
                                          Image.asset("assets/images/location.png",height: 16.0,width: 16.0),
                                          SizedBox(height: 18.0,),
                                          Expanded(child: Container(decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(5.0),
    
                                          ),
                                          child: Padding(padding: EdgeInsets.all(3.0),
                                          child: TextField(
                                            onChanged: (val){
                                              findPlace(val);
                                            },
                                            controller: dropOffTextEditingController,
                                            decoration: InputDecoration(hintText: "Where to?",
                                            fillColor: Colors.grey,
                                            filled: true,
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0)),
                                          ),),))
                                        ],
                                      ),
                                    ],
                                  ),),
                                  ),

                                  SizedBox(height: 10.0,),
                                  (placePredictionsList.length > 0) 
                                  ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: ListView.separated(itemBuilder: (context, index){
                                      return PredictionTile(placePredictions: placePredictionsList[index],);
                                    }, separatorBuilder: (BuildContext context, int index)=> DividerWidget(), 
                                    itemCount: placePredictionsList.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),),
                                  ) 
                                  : Container(),
          ],

        ),
      ),
    );
  }

  void findPlace(String placeName) async{
    if (placeName.length > 1){
      String autocompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in";
      var res = await RequestAssistant.getRequest(autocompleteUrl);

      if(res == "failed"){
        return;
      }
      if(res["status"]=="OK"){
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placePredictionsList = placesList;

        });
      }
  }
}
}

class PredictionTile extends StatelessWidget {

  final PlacePredictions placePredictions;

  //const PredictionTile(Key? key, this.placePredictions) : super(key: key);
  PredictionTile({required this.placePredictions});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        getPlaceAddressDetails(placePredictions.place_id, context);

      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
          children: [
            Icon(Icons.add_location),
            SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0,),
                  Text(placePredictions.main_text,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 3.0,),
                  Text(placePredictions.secondary_text,overflow: TextOverflow.ellipsis),
                  SizedBox(height: 8.0,),
                ],
              ),
            )
          ],
        ),
        SizedBox(width: 10.0,)
          ],
        )
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async{

    //showDialog(context: context, builder: (BuildContext context) => ProgressDialog(message: "Setting Drop off, Please wait..."));
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(res == "failed"){
      return;
    }

    if(res["status"] == "OK"){
      Address address = Address(
      res["result"]["formatted_address"],
      res["result"]["name"],
      placeId,
      res["result"]["geometry"]["location"]["lat"],
      res["result"]["geometry"]["location"]["lng"],
    );

      Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(address);
      print("This is Drop off location");
      print(address.placeName); 

      Navigator.pop(context, "obtainDirection");     
    }
  }
}