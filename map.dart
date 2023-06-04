import 'dart:async';

import 'package:farespy/Assistants/asst_methods.dart';
import 'package:farespy/DataHandler/app_data.dart';
import 'package:farespy/Models/direction_details.dart';
import 'package:farespy/divider_widget.dart';
import 'package:farespy/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const String idScreen = "mapScreen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  //DirectionDetails tripDirectionDetails;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late Position currentPosition;
  var geolocator = Geolocator();

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  void locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permission denied forever, show an error message or prompt the user to grant permissions
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permissions Denied'),
          content:
              Text('Please grant location permissions to use this feature.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      // Permission denied, request permissions
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission still not granted, show an error message or prompt the user to grant permissions
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permissions Denied'),
            content:
                Text('Please grant location permissions to use this feature.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLangPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLangPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your address: " + address);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        key: scaffoldKey,
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: [
                Container(height: 165,
                child: DrawerHeader(decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Image.asset("assets/images/profile.png",height: 65.0,width: 65.0,),
                    SizedBox(width: 6.0,),
                    Text("Visit Profile"),

                  ],
                )),),
                DividerWidget(),
                SizedBox(height: 12.0,),

                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History"),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About"),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                // locatePosition();
              },
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
            ),

            Positioned(
              top: 45.0,
              left:22.0,
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();

                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7)),]
                  ),
                  child: CircleAvatar(backgroundColor: Colors.white,
                  child: Icon(Icons.menu,color: Colors.black,),
                  radius: 20.0,
                  
                ),
                          ),
              ),),

            Positioned(
                
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: 320.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7)),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.0,
                        ),
                        Text("Hi"),
                        Text("Where to?"),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () async{
                            var res = Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage()));

                            if(res == "obtainDirection"){
                              await getPlaceDirection;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 16.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.7, 0.7)),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("Search Drop off")
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0,),
                        Row(children: [
                          Icon(Icons.home,color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Provider.of<AppData>(context).pickUpLocation != null 
                            ? Provider.of<AppData>(context).pickUpLocation!.placeName
                            : "Add Home"),
                            SizedBox(height: 4.0,),
                            Text("Your living home address"),

                          ],),
                        ],),
                        SizedBox(height: 10.0,),
                        DividerWidget(),
                        SizedBox(height: 16.0,),
                        Row(children: [
                          Icon(Icons.work,color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Work"),
                            SizedBox(height: 4.0,),
                            Text("Your office address"),
                            
                          ],),
                        ],),
                      ],
                    ),
                  ),
                )),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: locatePosition,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async{
    var initialPos = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context,listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longitude);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    // setState(() {
    //   tripDirectionDetails = details!;
    // });

    Navigator.pop(context);

    print("This is encoded pints:: ");

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details?.encodedPoints);
    if(decodedPolyLinePointsResult.isNotEmpty){
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) { 
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
      polylineId: PolylineId("PolylineID"),
      jointType: JointType.round,
      points: pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true);

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude){
      latLngBounds= LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);

    }

    else if(pickUpLatLng.longitude > dropOffLatLng.longitude){
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude){
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));

    }
    else{
      latLngBounds= LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"));

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Dropoff location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"));

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"));
    
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("dropOffId"));

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });



  }
}


