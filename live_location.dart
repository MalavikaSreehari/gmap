import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:farespy/Assistants/maps_utils.dart';
import 'package:farespy/fare_display.dart';
import 'package:farespy/global/config_maps.dart';
import 'package:farespy/paymentone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'dart:math';
import 'package:location/location.dart' as loc;


//import 'package:location/location.dart';


class LiveLoc extends StatefulWidget {
  LiveLoc({super.key, this.startPoint, this.endPoint});

  final DetailsResult? startPoint;
  final DetailsResult? endPoint;
  @override
  State<LiveLoc> createState() => _LiveLocState();
}

class _LiveLocState extends State<LiveLoc> {

  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late CameraPosition _initialPosition;
  double distance = 0.0;
  
  

  loc.LocationData? currentLocation;

  
  
  void getCurrentLocation() async {
    loc.Location location = loc.Location();
location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
GoogleMapController googleMapController = await _controller.future;
location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
setState(() {});
      },
    );
  }
  

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.purpleAccent, points: polylineCoordinates,
        );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        placesKey,
        PointLatLng(widget.startPoint!.geometry!.location!.lat!, widget.startPoint!.geometry!.location!.lng!),
        PointLatLng(widget.endPoint!.geometry!.location!.lat!, widget.endPoint!.geometry!.location!.lng!),
        travelMode: TravelMode.driving,
        );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    
    double totalDistance = 0;
      for(var i = 0; i < polylineCoordinates.length-1; i++){
           totalDistance += calculateDistance(
                polylineCoordinates[i].latitude, 
                polylineCoordinates[i].longitude, 
                polylineCoordinates[i+1].latitude, 
                polylineCoordinates[i+1].longitude);
      }

      setState(() {
         distance = double.parse(totalDistance.toStringAsFixed(2));
      });

      _addPolyLine();


  }

  double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
        cos(lat1 * p) * cos(lat2 * p) * 
        (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}
  
  @override
  void initState() {
    _getPolyline();
    getCurrentLocation();
    super.initState();
    _initialPosition = CameraPosition(
        target: LatLng(widget.startPoint!.geometry!.location!.lat!,
            widget.startPoint!.geometry!.location!.lng!),
        zoom: 14.4746);
  }

  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(
          markerId: const MarkerId("currentLocation"),
          position: LatLng(
              currentLocation!.latitude!, currentLocation!.longitude!),
        ),
    Marker(markerId: MarkerId('start'),
    position: LatLng(widget.startPoint!.geometry!.location!.lat!, widget.startPoint!.geometry!.location!.lng!)),
    Marker(markerId: MarkerId('end'),
    position: LatLng(widget.endPoint!.geometry!.location!.lat!, widget.endPoint!.geometry!.location!.lng!))
  };
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children:[ GoogleMap(initialCameraPosition: CameraPosition(
        target: LatLng(
            currentLocation!.latitude!, currentLocation!.longitude!),
        zoom: 13.5,
      ),
          polylines: Set<Polyline>.of(polylines.values),
          zoomControlsEnabled: false,
          markers: Set.from(_markers),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
                         
                          Future.delayed(
                              Duration(milliseconds: 2000),
                              () {controller.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      MapUtils.boundsFromLatLngList(
                                          _markers.map((loc) => loc.position).toList()),
                                      1));
                                      _getPolyline();
                                      },
                          );
                        },),
                        Positioned(
                    top: 0.0,
                right: 50.0,
                // height: 40,
                //width: 110,
                    child: Container( 
                     child: Card( 
                         child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text("Total Distance: " + distance.toStringAsFixed(2) + " km",
                                         style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,color: Colors.blue))
                         ),
                     )
                    )
                 ),
                 Positioned(
                bottom: 16.0,
                left: 16.0,
                height: 40,
                width: 110,

                child: ElevatedButton(onPressed: (){
                  print(distance);
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FareDisplay(distance: distance)),
                        );

                },style: ElevatedButton.styleFrom(backgroundColor: Color(0xff93C561)),
                 child: Text("Get Fare",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),),),)
          ]
        ),
      ),
    );
  }
}