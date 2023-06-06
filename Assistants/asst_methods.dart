import 'package:farespy/Assistants/req_asst.dart';
import 'package:farespy/DataHandler/app_data.dart';
import 'package:farespy/Models/address.dart';
import 'package:farespy/Models/direction_details.dart';
import 'package:farespy/global/config_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    print(url);
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickupAddress = Address(
        placeAddress,
        response["results"][0]["address_components"][0]["long_name"],
        response["results"][0]["place_id"],
        position.latitude,
        position.longitude,
      );

      userPickupAddress.latitude = position.latitude;
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$placesKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(res["routes"][0]["legs"][0]["distance"]["value"],
      res["routes"][0]["legs"][0]["distance"]["text"],
      res["routes"][0]["legs"][0]["duration"]["value"],
       res["routes"][0]["legs"][0]["duration"]["text"],
       res["routes"][0]["overview_polyline"]["points"],
    );

    return directionDetails;
  }

  static int calculateFare(DirectionDetails directiondetails)
  {
    double timeTravelledFare= (directiondetails.durationValue /60 ) * 0.20;
    double distanceTravelledFare = (directiondetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;

    return totalFareAmount.truncate();
  }
}
